# Hibernate 6 migration

Spring Boot 3.x brought Hibernate 6 (replacing Hibernate 5.6.x from SB 2.7). Spring Boot 4.x stays on the Hibernate 6 line but with further point-release changes. The biggest breaks come from the 5 → 6 jump:

- All persistence annotations now live in `jakarta.persistence` (see `jakarta-migration.md`).
- Several `Dialect` classes were merged into single per-vendor dialects.
- The `UserType` API was rewritten.
- The `@Type` annotation is deprecated in favor of `@JdbcTypeCode` + `@JavaType`.
- ID generation defaults changed for `GenerationType.AUTO`.

If the project doesn't depend on `spring-boot-starter-data-jpa` or `hibernate-core`, skip this file.

## Dialect class renames

Hibernate 6 collapsed version-specific dialects into single per-vendor dialects that detect the database version at runtime. The old version-specific classes were removed.

| Removed | Replacement |
|---|---|
| `org.hibernate.dialect.MySQL5Dialect` | `org.hibernate.dialect.MySQLDialect` |
| `org.hibernate.dialect.MySQL57Dialect` | `org.hibernate.dialect.MySQLDialect` |
| `org.hibernate.dialect.MySQL8Dialect` | `org.hibernate.dialect.MySQLDialect` |
| `org.hibernate.dialect.PostgreSQL95Dialect` | `org.hibernate.dialect.PostgreSQLDialect` |
| `org.hibernate.dialect.PostgreSQL10Dialect` | `org.hibernate.dialect.PostgreSQLDialect` |
| `org.hibernate.dialect.Oracle10gDialect` | `org.hibernate.dialect.OracleDialect` |
| `org.hibernate.dialect.Oracle12cDialect` | `org.hibernate.dialect.OracleDialect` |
| `org.hibernate.dialect.SQLServer2012Dialect` | `org.hibernate.dialect.SQLServerDialect` |

These usually appear in `application.properties`/`application.yml` rather than Java source:

```
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
```

In most cases you can simply remove the `hibernate.dialect` property entirely — Hibernate 6 auto-detects it from the JDBC connection.

## `UserType` API

The old `org.hibernate.usertype.UserType` interface was rewritten. Pre-6 implementations look like:

```java
public class MyType implements UserType {
    public int[] sqlTypes() { ... }
    public Class returnedClass() { ... }
    public Object nullSafeGet(ResultSet rs, String[] names, ...) { ... }
    public void nullSafeSet(PreparedStatement st, Object value, int index, ...) { ... }
    // ...
}
```

In Hibernate 6, `UserType` is generic and most methods changed signature. Two paths:

**Option A — `UserTypeLegacyBridge`**: keep the old implementation, bridge it forward. Simplest if the type isn't on a hot path.

**Option B — Rewrite to the new `UserType<J>` interface**: clean but every method signature changes.

This is an **ambiguity point — ask the developer** which path before rewriting.

## `@Type` annotation

`org.hibernate.annotations.Type(type = "...")` with string-named types is deprecated. Replace with:

- `@JdbcTypeCode(SqlTypes.JSON)` for JSON columns (with Hibernate 6's built-in JSON support).
- `@JdbcTypeCode(SqlTypes.ARRAY)` for arrays.
- `@Type(MyUserType.class)` (class reference, not string) for custom user types.

Common pre-6 pattern that needs rewriting:

```java
// Old
@Type(type = "json")
@Column(columnDefinition = "jsonb")
private MyJsonClass payload;
```

```java
// New
@JdbcTypeCode(SqlTypes.JSON)
@Column(columnDefinition = "jsonb")
private MyJsonClass payload;
```

This typically also removes the need for a `hibernate-types` (vladmihalcea) dependency. If the project depends on `com.vladmihalcea:hibernate-types-*`, flag it for the developer — they probably want to remove it after migration.

## ID generation defaults

In Hibernate 5, `@GeneratedValue(strategy = GenerationType.AUTO)` on a `Long` field typically picked `IDENTITY` or `SEQUENCE`. In Hibernate 6, `AUTO` more aggressively picks `SEQUENCE` and may create a `hibernate_sequence` if one doesn't exist.

If the project has explicit `@SequenceGenerator` annotations, they should keep working. If it relies on `AUTO` and the schema doesn't have a matching sequence, the app will fail at startup with a missing-sequence error. This is a **runtime** issue, not a compile one — flag it in the final report.

## Query parameter strictness

Hibernate 6 is stricter about positional parameters in JPQL/HQL. Patterns like `WHERE x.id = ?` are rejected; use `WHERE x.id = ?1` (positional) or `WHERE x.id = :id` (named).

Also a compile-time non-issue but a startup-time failure — flag in the final report if the project has many `@Query` annotations.

## Naming strategy

The default physical naming strategy (`SpringPhysicalNamingStrategy`) is unchanged in behavior, but its package moved in early Spring Boot 3 releases. If `application.properties` references it by FQN, the import is:

```
spring.jpa.hibernate.naming.physical-strategy=org.springframework.boot.orm.jpa.hibernate.SpringPhysicalNamingStrategy
```

Verify against the version in the project's pom.xml.

## When to pause and ask

- Any custom `UserType` implementation (Option A vs B above).
- Custom `Dialect` subclass (likely needs a rewrite against the new dialect SPI).
- Custom `org.hibernate.type.BasicType` registrations.
- Explicit `hibernate-types` library usage that can be replaced with native Hibernate 6 features.
