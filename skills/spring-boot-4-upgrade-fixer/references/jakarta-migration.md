# Jakarta EE migration (`javax.*` → `jakarta.*`)

This is the highest-volume change. Spring Boot 3.0 moved to Jakarta EE 9, which renamed the namespace from `javax.*` to `jakarta.*` for several specifications. **The rename is selective — not every `javax` package moves.** Always verify per-package; never do a blind global replace.

## Packages that MUST move to `jakarta.*`

These are Jakarta EE specifications that were renamed:

| Old | New |
|---|---|
| `javax.servlet.*` | `jakarta.servlet.*` |
| `javax.servlet.http.*` | `jakarta.servlet.http.*` |
| `javax.servlet.annotation.*` | `jakarta.servlet.annotation.*` |
| `javax.persistence.*` | `jakarta.persistence.*` |
| `javax.persistence.criteria.*` | `jakarta.persistence.criteria.*` |
| `javax.validation.*` | `jakarta.validation.*` |
| `javax.validation.constraints.*` | `jakarta.validation.constraints.*` |
| `javax.transaction.Transactional` | `jakarta.transaction.Transactional` |
| `javax.transaction.UserTransaction` | `jakarta.transaction.UserTransaction` |
| `javax.annotation.PostConstruct` | `jakarta.annotation.PostConstruct` |
| `javax.annotation.PreDestroy` | `jakarta.annotation.PreDestroy` |
| `javax.annotation.Resource` | `jakarta.annotation.Resource` |
| `javax.annotation.Priority` | `jakarta.annotation.Priority` |
| `javax.mail.*` | `jakarta.mail.*` |
| `javax.activation.*` | `jakarta.activation.*` (comes along with mail) |
| `javax.websocket.*` | `jakarta.websocket.*` |
| `javax.json.*` | `jakarta.json.*` |
| `javax.jms.*` | `jakarta.jms.*` |
| `javax.ws.rs.*` | `jakarta.ws.rs.*` |
| `javax.enterprise.*` (CDI) | `jakarta.enterprise.*` |
| `javax.inject.*` | `jakarta.inject.*` |
| `javax.ejb.*` | `jakarta.ejb.*` |
| `javax.xml.bind.*` (JAXB) | `jakarta.xml.bind.*` |
| `javax.xml.soap.*` | `jakarta.xml.soap.*` |
| `javax.xml.ws.*` (JAX-WS) | `jakarta.xml.ws.*` |

## Packages that STAY on `javax.*` (Java SE, not Jakarta EE)

**Never rewrite these.** They are part of the Java SE platform and have no `jakarta.*` equivalent. Rewriting them will fail to compile.

- `javax.crypto.*` (JCE)
- `javax.cache.*` (JCache / JSR-107 — common with Spring caching + Ehcache; it never joined Jakarta and stays `javax.cache`)
- `javax.net.*` and `javax.net.ssl.*`
- `javax.naming.*` (JNDI)
- `javax.sql.*` (e.g., `DataSource`, `RowSet` — JDBC extension; the `jakarta.persistence` rename does NOT cover this)
- `javax.security.auth.*`, `javax.security.cert.*`, `javax.security.sasl.*`
- `javax.sound.*`
- `javax.swing.*`, `javax.imageio.*`, `javax.print.*`, `javax.accessibility.*`
- `javax.management.*` (JMX)
- `javax.script.*`
- `javax.tools.*`
- `javax.xml.*` EXCEPT `javax.xml.bind`, `javax.xml.soap`, `javax.xml.ws` (those three moved; the rest, like `javax.xml.parsers`, `javax.xml.transform`, `javax.xml.xpath`, are SE and stay)
- `javax.lang.model.*`, `javax.annotation.processing.*`

## How to apply

1. Let the compiler list the broken `javax.*` imports. Don't pre-scan.
2. For each broken import, check the tables above. If it's in the Jakarta list, rename to `jakarta.*`. If it's in the SE list, the error is something else — leave the import alone.
3. When you rename the import, also rename the fully-qualified usages in the file if any (e.g., `javax.persistence.EntityManager` used as a fully-qualified name in a method signature).
4. **Check `pom.xml`**: if the project had an explicit `<dependency>` on `javax.servlet:javax.servlet-api`, `javax.persistence:javax.persistence-api`, `javax.validation:validation-api`, or similar, those need to become their Jakarta equivalents (`jakarta.servlet:jakarta.servlet-api`, etc.) — or be removed entirely if Spring Boot's starters bring them transitively (usually the case for web and data-jpa).

## `javax.transaction.Transactional` vs `org.springframework.transaction.annotation.Transactional`

Spring code typically uses `org.springframework.transaction.annotation.Transactional`, not `javax.transaction.Transactional`. Don't rewrite the Spring one — it never had a `javax`/`jakarta` rename to do. Only the JTA `javax.transaction.Transactional` moves to `jakarta.transaction.Transactional`.

## `@PostConstruct` / `@PreDestroy`

These moved from `javax.annotation` to `jakarta.annotation`. They're not in the JDK any longer on the module path; Spring Boot 3+ brings `jakarta.annotation-api` transitively via `spring-boot-starter`. If a project explicitly depends on `javax.annotation:javax.annotation-api`, remove it.

## Bean Validation (`javax.validation` → `jakarta.validation`)

All the constraint annotations move: `@NotNull`, `@NotBlank`, `@Size`, `@Min`, `@Max`, `@Email`, `@Pattern`, etc. The `Validator` interface, `ConstraintValidator`, `ConstraintValidatorContext`, and `Valid` all move too. `@Valid` on a controller parameter is `jakarta.validation.Valid` now.
