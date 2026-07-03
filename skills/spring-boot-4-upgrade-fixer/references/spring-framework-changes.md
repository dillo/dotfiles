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

Despite long-standing community chatter, `RestTemplate` is **not** removed. It's in maintenance mode but still ships and works. Don't rewrite calls from `RestTemplate` to `RestClient` or `WebClient` as part of an upgrade — that's a refactor, not a migration. Leave it alone.

`RestClient` (Spring 6.1+) and `WebClient` are options for new code, but converting existing code is out of scope here.

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

## Removed: `LinkedMultiValueMap` constructor with `int`

A specific tiny one that bites occasionally: `new LinkedMultiValueMap<>(initialCapacity)` where `initialCapacity` is an `int` was removed. Use the default constructor.

## `Nullable` annotations

Spring 6 moved from `org.springframework.lang.Nullable`/`NonNull` toward JSpecify (`org.jspecify.annotations.Nullable`) over the 6.x line, with the Spring annotations still present. Spring 7 deprecates the Spring-owned annotations further. **Don't rewrite annotations** as part of this upgrade; it's optional and orthogonal.

## `ApplicationContextAware`, `BeanFactoryAware`, etc.

Unchanged. If you see compile errors on these, look elsewhere — they aren't part of the migration.

## When to pause and ask

- Anywhere the project subclasses a Spring class (vs. implementing an interface). The class may have been redesigned.
- Custom `HandlerInterceptor` adapters — `HandlerInterceptorAdapter` was deprecated in Spring 5 and removed in 6. Implement `HandlerInterceptor` directly (all methods are `default` now).
