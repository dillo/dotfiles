# Spring Framework 6/7 changes

Spring Boot 3.x bundles Spring Framework 6, and Spring Boot 4.x bundles Spring Framework 7. Across both jumps a long tail of deprecated APIs was removed. Most code will be unaffected; the cases below are the ones that actually surface in real projects.

## `WebMvcConfigurerAdapter` was already gone

If you see `extends WebMvcConfigurerAdapter`, it was removed in Spring Framework 5. The fix is to implement the `WebMvcConfigurer` interface directly (all methods have default implementations):

```java
// Old
public class WebConfig extends WebMvcConfigurerAdapter {
    @Override public void addInterceptors(InterceptorRegistry r) { ... }
}

// New
public class WebConfig implements WebMvcConfigurer {
    @Override public void addInterceptors(InterceptorRegistry r) { ... }
}
```

## `RestTemplate` and `WebClient` are still here

`RestTemplate` is **not** removed. It still ships and works in Spring Framework 7, though it's now deprecated in the documentation (a formal `@Deprecated` is planned for 7.1). Don't rewrite calls from `RestTemplate` to `RestClient` or `WebClient` as part of an upgrade — that's a refactor, not a migration. Leave it alone, but mention the deprecation in the final report so the developer can plan.

One real compile break in this area: configuring `RestTemplate` with **Apache HttpClient 4** (`HttpComponentsClientHttpRequestFactory` + `org.apache.http.*`). Spring Framework 6 moved to **HttpClient 5** (`org.apache.hc.client5.*`). The factory class name is the same but it now wraps HttpClient 5 types — the pom needs `org.apache.httpcomponents.client5:httpclient5` and the imports change. Similarly, OkHttp3 client support was removed in Framework 7.

## `ListenableFuture` is removed (Framework 7)

`org.springframework.util.concurrent.ListenableFuture` and `ListenableFutureCallback` are gone — everything returns `CompletableFuture` now. Classic hit: Spring Kafka send callbacks written against Boot 2.x:

```java
// Old
ListenableFuture<SendResult<K, V>> f = kafkaTemplate.send(topic, msg);
f.addCallback(onSuccess, onFailure);

// New
CompletableFuture<SendResult<K, V>> f = kafkaTemplate.send(topic, msg);
f.whenComplete((result, ex) -> { if (ex == null) { ... } else { ... } });
```

Same pattern for `AsyncRestTemplate` remnants and `@Async` methods declared to return `ListenableFuture`.

## `HttpMethod` is a class, not an enum (Framework 6)

`switch` statements over `HttpMethod`, `HttpMethod.values()`, and `ordinal()`/`name()`-as-enum tricks fail to compile. Replace `switch` with `if`/`else` on `equals`, and `HttpMethod.valueOf(String)` still exists for parsing.

## `HttpHeaders` no longer implements `MultiValueMap` (Framework 7)

Code that passed `HttpHeaders` where a `MultiValueMap<String, String>` was expected, or called `Map` methods on it, breaks. `add`/`set`/`getFirst` still exist; for a genuine map view use `headers.asMultiValueMap()` (deprecated bridge). Rework call sites to the direct `HttpHeaders` API where trivial; ask if the map is used structurally.

## Spring Data repository methods

`getOne(id)` (deprecated since Spring Data 2.5) and `getById(id)` (deprecated since 2.7) are replaced by `getReferenceById(id)` — same lazy-reference semantics, direct rename. Note `findById` returns `Optional` (since Spring Data 2.0) — only relevant for jumps from very old code.

## `ResponseStatusException` constructors

Some constructors of `ResponseStatusException` were marked deprecated and then removed. The currently supported ones take an `HttpStatusCode` (the new parent of `HttpStatus`):

```java
throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Not found");
```

This still compiles because `HttpStatus implements HttpStatusCode`. If you see a compile error here, the call probably used a `(int statusCode, String reason, Throwable cause)` form — replace `int` with `HttpStatusCode.valueOf(statusCode)`.

## `HttpStatus` vs `HttpStatusCode`

Spring 6 introduced `HttpStatusCode` as an interface and made `HttpStatus` implement it. Method signatures across the framework now use `HttpStatusCode`. For most call sites this is source-compatible. If a project has its own subclass of `HttpStatus` or holds raw `int` status codes, expect a few signature mismatches — convert with `HttpStatusCode.valueOf(int)`.

## `ResponseEntity` and headers

`ResponseEntity.BodyBuilder` API is unchanged. `HttpHeaders` had a small number of methods removed (the ones already deprecated for several years). If you see a compile error on `HttpHeaders.add(...)` or `.set(...)`, those still exist — re-read the error; it's likely a different method.

## `@RequestMapping` on interfaces

Spring 6 still supports `@RequestMapping` (and `@GetMapping`, etc.) on interface methods, but the annotation must be on the implementing class (or visible via interface attribute inheritance settings). No change usually needed.

## Removed packages/modules (Framework 7)

- `org.springframework.orm.hibernate5` — replaced by `org.springframework.orm.jpa.hibernate`. Code using `HibernateTransactionManager`/`LocalSessionFactoryBean` from the old package needs the new one.
- `spring-jcl` — replaced by Apache Commons Logging 1.3.x (usually invisible; matters only if the pom excludes/pins `spring-jcl`).
- Path-mapping options `suffixPatternMatch`, `trailingSlashMatch`, `favorPathExtension` on `WebMvcConfigurer.configurePathMatch` — delete the calls; the behaviors are gone (note the runtime consequence: `GET /foo/` no longer matches `/foo`).

## `Nullable` annotations

Spring 6 moved from `org.springframework.lang.Nullable`/`NonNull` toward JSpecify (`org.jspecify.annotations.Nullable`) over the 6.x line, with the Spring annotations still present. Spring 7 deprecates the Spring-owned annotations further. **Don't rewrite annotations** as part of this upgrade; it's optional and orthogonal.

## `ApplicationContextAware`, `BeanFactoryAware`, etc.

Unchanged. If you see compile errors on these, look elsewhere — they aren't part of the migration.

## When to pause and ask

- Anywhere the project subclasses a Spring class (vs. implementing an interface). The class may have been redesigned.
- Custom `HandlerInterceptor` adapters — `HandlerInterceptorAdapter` was deprecated in Spring 5 and removed in 6. Implement `HandlerInterceptor` directly (all methods are `default` now).
