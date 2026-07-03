# Jackson 2 → 3 migration

Spring Boot 4 uses **Jackson 3** as its JSON library. Jackson 3 changed its Maven group IDs and package namespace: `com.fasterxml.jackson.*` → `tools.jackson.*` — with one deliberate exception: **`jackson-annotations` keeps the `com.fasterxml.jackson.core` group and `com.fasterxml.jackson.annotation` package**. So `@JsonProperty`, `@JsonIgnore`, `@JsonInclude` on DTOs usually need *no* change; code that touches `ObjectMapper` and friends does.

If the project has no Jackson customization (no `ObjectMapper` beans, no custom serializers, no `@JsonComponent`), there is likely nothing to do in this file.

## Package / class moves

| Old (Jackson 2) | New (Jackson 3) |
|---|---|
| `com.fasterxml.jackson.databind.ObjectMapper` | `tools.jackson.databind.ObjectMapper` (construct via `tools.jackson.databind.json.JsonMapper.builder()`) |
| `com.fasterxml.jackson.databind.*` | `tools.jackson.databind.*` |
| `com.fasterxml.jackson.core.*` (streaming) | `tools.jackson.core.*` |
| `com.fasterxml.jackson.datatype.jsr310.JavaTimeModule` | built into Jackson 3 — delete the registration |
| `com.fasterxml.jackson.annotation.*` | **unchanged** |

Behavioral defaults changed too (e.g., Java Time support built in and written as ISO strings by default, fail-on-unknown differences). Compile fixes are mechanical; note in the final report that serialization output should be diff-tested.

## Spring-side renames

| Old | New |
|---|---|
| `@JsonComponent` | `@JacksonComponent` |
| `@JsonMixin` | `@JacksonMixin` |
| `JsonObjectSerializer` / `JsonObjectDeserializer` | `ObjectValueSerializer` / `ObjectValueDeserializer` |
| `Jackson2ObjectMapperBuilder` | `JsonMapper.builder()` (Jackson's own builder) |
| `Jackson2ObjectMapperBuilderCustomizer` | `JsonMapperBuilderCustomizer` |
| `MappingJackson2HttpMessageConverter` | `JacksonJsonHttpMessageConverter` |

Property prefixes moved as well: `spring.jackson.read.*` / `spring.jackson.write.*` → `spring.jackson.json.read.*` / `spring.jackson.json.write.*` (see `property-renames.md`).

## The escape hatch: `spring-boot-jackson2`

Boot 4 ships a **deprecated** `spring-boot-jackson2` module that keeps Jackson 2 auto-configuration working (properties under `spring.jackson2.*`). Spring Framework 7 still supports Jackson 2 but deprecates it, with removal planned during the 7.x line — this buys time, it is not a destination.

## When to pause and ask

Jackson migration is an **ambiguity point** when the project has non-trivial Jackson code. Present both options:

- **Option A — migrate to Jackson 3 now**: mechanical package/class renames per the tables above. Right choice when customization is light (a few modules, a customizer bean).
- **Option B — add `spring-boot-jackson2` and defer**: right choice when the project has many custom serializers, wire-format-sensitive consumers, or third-party libraries still publishing Jackson 2 modules (a `com.fasterxml.jackson.*` dependency that has no `tools.jackson` release yet forces this).

Check `mvn dependency:tree` for third-party `com.fasterxml.jackson.*` module dependencies (e.g., `jackson-datatype-*`, `jackson-module-kotlin` equivalents from other vendors) before recommending Option A.
