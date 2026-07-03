# Test infrastructure changes

## `@MockBean` and `@SpyBean` deprecated → `@MockitoBean` and `@MockitoSpyBean`

Spring Boot 3.4 introduced `@MockitoBean` and `@MockitoSpyBean` in `org.springframework.test.context.bean.override.mockito` as proper replacements. The old `@MockBean` and `@SpyBean` in `org.springframework.boot.test.mock.mockito` were deprecated then and have been removed in Spring Boot 4.x.

| Old (`org.springframework.boot.test.mock.mockito`) | New (`org.springframework.test.context.bean.override.mockito`) |
|---|---|
| `@MockBean` | `@MockitoBean` |
| `@SpyBean` | `@MockitoSpyBean` |

```java
// Old
@SpringBootTest
class MyTest {
    @MockBean MyService service;
    @SpyBean MyOtherService other;
}

// New
@SpringBootTest
class MyTest {
    @MockitoBean MyService service;
    @MockitoSpyBean MyOtherService other;
}
```

The behavior is intentionally the same; only the import and annotation name change.

## JUnit 4 is gone from the starter

`spring-boot-starter-test` stopped including JUnit 4 (`junit:junit:4.x`) starting in Spring Boot 2.4 and the `junit-vintage-engine` was removed by default in 3.0. If the project still has JUnit 4 tests:

- Either add `org.junit.vintage:junit-vintage-engine` as a test dependency to keep them running.
- Or migrate the tests to JUnit 5 (out of scope for this skill — flag for the developer).

Compile errors that look like `package org.junit does not exist` (vs. `org.junit.jupiter.api`) indicate stranded JUnit 4 tests. Ask the developer.

## `@RunWith(SpringRunner.class)` → `@ExtendWith(SpringExtension.class)`

If JUnit 4 was the test framework, `@RunWith(SpringRunner.class)` was the entry point. Under JUnit 5 it's `@ExtendWith(SpringExtension.class)` — but `@SpringBootTest`, `@WebMvcTest`, `@DataJpaTest`, etc. already include `@ExtendWith(SpringExtension.class)` as meta-annotations, so it's almost never needed explicitly.

If you see `@RunWith` annotations after migrating tests to JUnit 5, just remove them.

## `MockMvc` and `WebTestClient`

Unchanged for the common cases. `MockMvcBuilders.standaloneSetup(...)` and `MockMvcBuilders.webAppContextSetup(...)` still work. `WebTestClient` API surface is stable.

## `TestRestTemplate`

Unchanged. Still in `org.springframework.boot.test.web.client`.

## `@AutoConfigureMockMvc`, `@AutoConfigureTestDatabase`, slice-test annotations

All still present, all still work the same way.

## When to pause and ask

- A test base class that subclasses something from the Spring or JUnit test framework (e.g., `AbstractTransactionalJUnit4SpringContextTests`) — needs a rewrite to JUnit 5 patterns.
- Custom Mockito extensions or `MockitoAnnotations.openMocks(this)` patterns interacting with Spring — verify behavior didn't change.
