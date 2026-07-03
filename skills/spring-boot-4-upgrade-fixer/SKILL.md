---
name: spring-boot-4-upgrade-fixer
description: Fix a Maven Java project that is broken after its pom.xml was bumped to Spring Boot 4.x (typically 4.1.0) and Java 25. Use this skill whenever a developer says their Spring Boot project won't compile after upgrading, mentions a Spring Boot major version bump (2.x or 3.x → 4.x), reports `javax`/`jakarta` import errors, `WebSecurityConfigurerAdapter` missing, `cannot find symbol` on Spring types, Hibernate dialect failures, or any other breakage clearly tied to a Spring Boot upgrade. Also use it preemptively when a developer asks to upgrade Spring Boot to 4.x — apply this skill after the version bump in pom.xml is complete. Drives a compile-only feedback loop with `mvn compile`, applies targeted fixes only to files that actually use Spring/Jakarta/Hibernate, and pauses to ask the developer when a migration is genuinely ambiguous (e.g., a hand-written Spring Security configuration that can be rewritten multiple ways).
---

# Spring Boot 4.x Upgrade Fixer

## What this skill is for

A developer has bumped a Maven project to **Spring Boot 4.x** (e.g., 4.1.0) on **Java 25**, and the project no longer compiles. Your job is to bring it back to a clean `mvn compile` by applying the breaking-change migrations that Spring Boot 3.x and 4.x introduced — without touching files that have nothing to do with Spring.

The build file (`pom.xml`) has already been updated to the target versions. You are not deciding what versions to use. You are fixing the wreckage.

## Why this matters

Going from Spring Boot 2.x straight to 4.x crosses *two* major version boundaries. The breaking changes pile up:

- **Jakarta EE rename** (Spring Boot 3.0): every `javax.servlet`, `javax.persistence`, `javax.validation`, `javax.transaction`, `javax.annotation` import has to move to `jakarta.*`. This is the single biggest source of compile errors.
- **Spring Security 6 rewrite** (Spring Boot 3.0): `WebSecurityConfigurerAdapter` is gone. Security configs become beans returning `SecurityFilterChain`.
- **Hibernate 6** (Spring Boot 3.0): `UserType` API changed, several dialect classes renamed, `@Type` annotation deprecated.
- **Removed deprecated APIs** (Spring Framework 6 and 7): a long tail of methods and classes the Spring team had been warning about.
- **Property renames** in `application.properties` / `application.yml`.
- **Test API changes** (Spring Boot 3.4+): `@MockBean` → `@MockitoBean`.

A naive "find and replace `javax` with `jakarta`" pass will break things — `javax.crypto`, `javax.naming`, `javax.sql`, `javax.security.auth` are Java SE packages that stay put. The rename is selective. That's why this skill works from compile errors rather than blind text substitution.

## Scope: which files you may touch

**Only edit files that actually use Spring, Jakarta, Hibernate, or Spring-related test infrastructure.** Concretely, a file is in scope if any of these are true:

- It imports `org.springframework.*`, `jakarta.*`, `javax.servlet.*`, `javax.persistence.*`, `javax.validation.*`, `javax.transaction.*`, `javax.annotation.*` (annotation), `javax.mail.*`, `javax.websocket.*`, or `org.hibernate.*`.
- It is annotated with a Spring stereotype: `@Component`, `@Service`, `@Repository`, `@Controller`, `@RestController`, `@Configuration`, `@SpringBootApplication`, `@SpringBootTest`, `@WebMvcTest`, `@DataJpaTest`, `@EnableXxx`.
- It is `application.properties`, `application.yml`, `bootstrap.properties`, or a profile variant of those (`application-*.yml`).
- It is `pom.xml` — but only to add a missing dependency that a Spring change requires (e.g., explicit `jakarta.servlet-api`). Do not change versions or remove dependencies without asking.

**Do not touch:**
- Pure utility classes with no Spring/Jakarta imports.
- Domain models that don't carry persistence or validation annotations.
- Config for unrelated tooling (Checkstyle, SpotBugs, Sonar, Docker, Helm).
- Build/CI files (`Dockerfile`, `helm_*.yaml`, `skaffold.yaml`, `*.sh`).
- Generated sources (anything under `target/`, `build/`, `generated-sources/`).

If a file outside the allow-list shows a compile error, stop and tell the developer — that is a signal something unexpected is going on, not permission to widen the blast radius.

## Workflow

Work in this exact loop. Don't try to fix everything in one pass from memory — let the compiler tell you what's actually broken.

### Step 1: Confirm the starting state

Read `pom.xml` and verify:
- `<spring-boot-starter-parent>` version is on the 4.x line (typically `4.1.0`).
- `<java.version>` is `25` (or the major version the developer is targeting).

If the bump hasn't actually happened yet, stop and tell the developer — this skill assumes the version change is already in `pom.xml`.

Also inventory which Spring modules the project uses. Grep `pom.xml` for `<artifactId>spring-boot-starter-*</artifactId>`. The list (web, security, data-jpa, actuator, webflux, etc.) tells you which migration areas are in play and which to ignore. There is no reason to think about Spring Security migration if the project doesn't depend on it.

### Step 2: Run the compiler and capture all errors

```
mvn -fae -B clean compile 2>&1 | tee /tmp/sb4-compile.log
```

- `-fae` = fail at end. This is essential. Without it, Maven stops at the first error and you only see one problem; you'll loop unnecessarily.
- `-B` = batch mode, no interactive prompts.
- Redirect to a file so you can grep it without re-running.

If compile passes immediately, run `mvn -B test-compile` too (test sources have their own breakage — `@MockBean`, etc.).

### Step 3: Categorize errors

Group compile failures into these buckets. Counts and a few examples per bucket are enough to plan from — don't read every stack trace.

| Bucket | Typical error signature | Reference |
|---|---|---|
| Jakarta rename | `package javax.servlet does not exist`, `package javax.persistence does not exist` | `references/jakarta-migration.md` |
| Spring Security 6 | `cannot find symbol: class WebSecurityConfigurerAdapter`, `method antMatchers ... is deprecated`, `method authorizeRequests ... has been removed` | `references/security-migration.md` |
| Hibernate 6 | `cannot find symbol: class MySQL57Dialect`, `UserType ... is not abstract`, `package org.hibernate.type does not exist` | `references/hibernate-migration.md` |
| Removed/changed Spring APIs | `cannot find symbol: method ...` on Spring types, deprecated removals | `references/spring-framework-changes.md` |
| Test API | `cannot find symbol: class MockBean` after Spring Boot 3.4+ | `references/test-migration.md` |
| Property rename (only surfaces at runtime, not compile) | n/a at compile time | `references/property-renames.md` |

A single file often hits multiple buckets. That's fine — fix all the issues in one file before moving to the next, so you don't re-open the same file repeatedly.

### Step 4: Apply fixes, narrowly

For each affected file:

1. Confirm it's in scope per the rules above. If not, stop and surface it.
2. Apply the migration for each error bucket present in that file. The reference files spell out the exact mechanical changes.
3. Preserve any existing logic that isn't part of the migration. You are not refactoring; you are only making it compile.

When you hit something **genuinely ambiguous** — most commonly a hand-rolled Spring Security config that could be rewritten as either a single `SecurityFilterChain` bean or split across multiple, or a Hibernate `UserType` that could be ported via `UserTypeLegacyBridge` or rewritten to the new API — **stop and ask the developer**. Show them:
- The file path and a snippet of the original code.
- 2–3 concrete migration options with the tradeoffs (one sentence each).
- Your recommendation if you have one, and why.

Don't pick silently. Security and persistence are exactly the places where a quiet wrong choice causes the worst incidents.

### Step 5: Re-run and iterate

After each round of edits:

```
mvn -fae -B clean compile 2>&1 | tee /tmp/sb4-compile.log
```

If the error count drops, continue. If you've run the loop twice and the same errors persist with no change, stop and report — something needs human judgment.

Once main sources compile, run test compile (`mvn -B test-compile`) and repeat the loop for test code.

### Step 6: Report

When `mvn compile` and `mvn test-compile` both pass, report:
- Files changed, grouped by migration bucket.
- Anything you skipped or flagged for the developer.
- A reminder that **compile passing is not the same as runtime correct.** Property renames in `application.yml` (see `references/property-renames.md`), behavior changes in Hibernate query parsing, and Security rule changes will only surface when the app runs. Recommend the developer run their test suite and start the app against a real datasource before considering the upgrade done.

## Things to resist

- **Don't run `find . -name "*.java" -exec sed -i 's/javax/jakarta/g'`.** It will rewrite `javax.crypto`, `javax.sql.DataSource`, `javax.naming.*`, and other Java SE packages that must stay on `javax`. Always go through the compiler.
- **Don't bump unrelated dependency versions** because you saw a warning. Stay focused on what's broken because of the Spring upgrade. Lombok, MapStruct, etc. may need bumps to support Java 25 — if so, ask the developer before changing versions.
- **Don't reformat files.** Edit only the lines that need to change for the migration. A diff that touches the whole file is impossible to review.
- **Don't invent new abstractions.** No new helper classes, no new packages. The job is to keep behavior the same and make it compile against the new APIs.
- **Don't suppress errors.** No `@SuppressWarnings("removal")` to silence a deprecated-API warning without fixing it. Deprecations that became removals in 4.x are the whole point of the migration.

## Reference files

Read these as needed when a particular bucket of errors comes up. They contain the exact code patterns and gotchas for each area.

- `references/jakarta-migration.md` — full `javax.*` → `jakarta.*` mapping, including the SE packages that stay on `javax`.
- `references/security-migration.md` — `WebSecurityConfigurerAdapter` → `SecurityFilterChain`, lambda DSL, matcher renames, `@EnableMethodSecurity`.
- `references/hibernate-migration.md` — dialect renames, `UserType` API, `@Type` → `@JdbcTypeCode`/`@JavaType`, generator changes.
- `references/spring-framework-changes.md` — removed/changed APIs in Spring Framework 6 and 7.
- `references/test-migration.md` — `@MockBean` → `@MockitoBean`, JUnit dependency changes.
- `references/property-renames.md` — `application.properties`/`yml` renames (runtime issues, not compile).
