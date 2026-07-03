# `application.properties` / `application.yml` renames

These don't surface as compile errors. They cause silent misconfiguration or startup failures at runtime, so they need to be checked by reading the config files directly.

Spring Boot ships a `spring-boot-properties-migrator` artifact that emits warnings at startup for properties that were renamed or removed. **Recommend the developer add it temporarily** as a dependency after compile passes:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-properties-migrator</artifactId>
    <scope>runtime</scope>
</dependency>
```

Run the app once, fix the warnings the migrator emits, then remove the dependency. That is the official path and it catches more than any static list can.

The most common renames to know about:

## Redis

| Old (SB 2.x) | New (SB 3.x+) |
|---|---|
| `spring.redis.host` | `spring.data.redis.host` |
| `spring.redis.port` | `spring.data.redis.port` |
| `spring.redis.password` | `spring.data.redis.password` |
| `spring.redis.timeout` | `spring.data.redis.timeout` |
| `spring.redis.lettuce.*` | `spring.data.redis.lettuce.*` |
| `spring.redis.jedis.*` | `spring.data.redis.jedis.*` |

## Elasticsearch

| Old | New |
|---|---|
| `spring.elasticsearch.rest.uris` | `spring.elasticsearch.uris` |
| `spring.elasticsearch.rest.username` | `spring.elasticsearch.username` |
| `spring.elasticsearch.rest.password` | `spring.elasticsearch.password` |
| `spring.data.elasticsearch.client.reactive.*` | `spring.elasticsearch.*` (mostly consolidated) |

## Sleuth / Micrometer Tracing

Spring Cloud Sleuth was discontinued. Tracing moved to Micrometer Tracing.

| Old | New |
|---|---|
| `spring.sleuth.*` | `management.tracing.*`, `management.zipkin.*` (and add `io.micrometer:micrometer-tracing-bridge-brave` or similar) |

This is a larger migration than a simple rename — flag for the developer.

## Hibernate / JPA

| Old | New |
|---|---|
| `spring.jpa.hibernate.use-new-id-generator-mappings` | Removed; always true in Hibernate 6 |
| `spring.jpa.properties.hibernate.dialect=...57Dialect` etc. | Use the merged dialect (see `hibernate-migration.md`), or remove entirely (auto-detect) |

## Server

Most `server.*` properties are unchanged. A few:

| Old | New |
|---|---|
| `server.servlet.session.cookie.same-site` | Same name; the parser is stricter (use `none`, `lax`, `strict` lowercase) |
| `server.tomcat.max-threads` | `server.tomcat.threads.max` |
| `server.tomcat.min-spare-threads` | `server.tomcat.threads.min-spare` |

## Actuator

The endpoint exposure model is unchanged:

```
management.endpoints.web.exposure.include=health,info,metrics
```

Some specific endpoint properties moved under the per-endpoint group:

| Old | New |
|---|---|
| `management.endpoint.health.show-details` | Same |
| `management.metrics.export.prometheus.enabled` | `management.prometheus.metrics.export.enabled` |

## Logging

Mostly unchanged. Logback and Log4j2 configs work as before.

## How to apply

1. Don't edit `application.yml`/`application.properties` proactively — you'd miss things and possibly break something.
2. Add the `spring-boot-properties-migrator` dependency in the final report's recommendations.
3. If a specific rename appears in your work (e.g., the project hard-codes `MySQL57Dialect` in `application.properties` and you're rewriting Java), make the property change at the same time so the developer doesn't get a startup error 30 seconds after thinking the migration is done.
