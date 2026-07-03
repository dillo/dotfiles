# Spring Boot 4 modularization

Spring Boot 4.0 split the monolithic `spring-boot` / `spring-boot-autoconfigure` jars into per-technology modules (`spring-boot-<technology>`). Two visible consequences: **auto-configuration classes changed packages**, and **several starters were renamed**.

## Auto-configuration package relocations

The pattern: classes move from `org.springframework.boot.autoconfigure.<tech>.*` to `org.springframework.boot.<tech>.autoconfigure.*`.

| Old | New |
|---|---|
| `org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration` | `org.springframework.boot.jdbc.autoconfigure.DataSourceAutoConfiguration` |
| `org.springframework.boot.autoconfigure.<tech>.XxxAutoConfiguration` | `org.springframework.boot.<tech>.autoconfigure.XxxAutoConfiguration` |

Where this bites:

1. **Class-based excludes** — compile error, easy to spot:
   ```java
   @SpringBootApplication(exclude = DataSourceAutoConfiguration.class)
   ```
   Fix the import to the new package. Same for `@ImportAutoConfiguration` and `@EnableAutoConfiguration(exclude = ...)`.

2. **String-based excludes** — **silent** at compile time, breaks at runtime (the exclude simply stops matching, so the auto-configuration activates again):
   ```
   spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration
   ```
   Grep `application*.properties`/`application*.yml` (and `@SpringBootTest(properties = ...)` in tests) for `autoconfigure` and update every FQN. Include this in the final report even if none were found, so the developer knows it was checked.

3. **Direct imports of Boot classes** in user code (error controllers, `WebServerFactoryCustomizer`, embedded-server tuning, `spring.factories`-era customizations). The compiler flags these; find the new package with the class's Javadoc or by searching `docs.spring.io/spring-boot/api`. Don't guess-and-loop more than twice per class.

4. **Custom auto-configurations** registered in `META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports` still work; the ancient `META-INF/spring.factories` registration (pre-Boot 2.7) does not. If the project registers its own auto-configuration via `spring.factories`, migrate the registration file — flag it to the developer.

## Starter renames

| Old | New |
|---|---|
| `spring-boot-starter-web` | `spring-boot-starter-webmvc` |
| `spring-boot-starter-web-services` | `spring-boot-starter-webservices` |
| `spring-boot-starter-oauth2-client` | `spring-boot-starter-security-oauth2-client` |
| `spring-boot-starter-oauth2-resource-server` | `spring-boot-starter-security-oauth2-resource-server` |

Each technology also gained a dedicated **test companion starter** (e.g., `spring-boot-starter-webmvc-test`). If test-compile fails on missing test auto-configuration classes (`@WebMvcTest` infrastructure, `MockMvc` types), the fix is usually adding the matching `-test` starter rather than hunting individual artifacts.

## Undertow is gone

Boot 4 requires Servlet 6.1; Undertow doesn't support it. The Undertow starter and embedded-server support were removed. Replace `spring-boot-starter-undertow` with Tomcat (remove the exclusion of `spring-boot-starter-tomcat`) or Jetty — **ask the developer which**, since thread-pool tuning (`server.undertow.*`) doesn't carry over.

## When to pause and ask

- The project ships its own auto-configuration library (a `*-spring-boot-starter` module of their own) — registration and package conventions both changed.
- Third-party starters (`*-spring-boot-starter` from other vendors) that fail with `package org.springframework.boot.autoconfigure... does not exist` inside the *dependency* — the dependency itself needs a Boot-4-compatible release; you can't fix it from this project. Check for a newer version and ask.
