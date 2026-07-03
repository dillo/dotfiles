# Spring Security 6/7 migration

Spring Boot 3.x ships Spring Security 6, and Spring Boot 4.x ships Spring Security 7. The big break happened in 6 — `WebSecurityConfigurerAdapter` was removed and the matcher API was overhauled. By 7, the lambda DSL is the only supported form for many configurers; the older non-lambda forms have been removed.

If the project doesn't depend on `spring-boot-starter-security`, skip this entire file.

## `WebSecurityConfigurerAdapter` is gone

The old pattern:

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests()
            .antMatchers("/public/**").permitAll()
            .anyRequest().authenticated()
            .and().formLogin();
    }
}
```

Becomes a bean that returns a `SecurityFilterChain`:

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/public/**").permitAll()
                .anyRequest().authenticated()
            )
            .formLogin(Customizer.withDefaults());
        return http.build();
    }
}
```

Key renames in this transition:

| Old | New |
|---|---|
| `extends WebSecurityConfigurerAdapter` + override `configure(HttpSecurity)` | `@Bean SecurityFilterChain securityFilterChain(HttpSecurity http)` returning `http.build()` |
| `authorizeRequests()` | `authorizeHttpRequests(auth -> ...)` (lambda DSL) |
| `antMatchers(...)` | `requestMatchers(...)` |
| `mvcMatchers(...)` | `requestMatchers(...)` |
| `regexMatchers(...)` | `requestMatchers(RegexRequestMatcher.regexMatcher(...))` |
| `.and().csrf().disable()` | `.csrf(csrf -> csrf.disable())` |
| `.and().formLogin()` | `.formLogin(Customizer.withDefaults())` |
| `.and().httpBasic()` | `.httpBasic(Customizer.withDefaults())` |
| `.and().oauth2Login()` | `.oauth2Login(Customizer.withDefaults())` |

In Spring Security 7, the non-lambda forms (`authorizeHttpRequests()` with chained methods, not a lambda) have been removed — always use the lambda.

## `WebSecurityCustomizer` for ignoring requests

The old `web.ignoring().antMatchers(...)` pattern becomes a `WebSecurityCustomizer` bean:

```java
@Bean
public WebSecurityCustomizer webSecurityCustomizer() {
    return web -> web.ignoring().requestMatchers("/static/**", "/favicon.ico");
}
```

Prefer `permitAll()` inside `authorizeHttpRequests` over `web.ignoring()` for most cases — `web.ignoring()` skips the whole security filter chain (no CSRF, no session, no auth context), which is rarely what you want.

## Authentication configuration

The old:

```java
@Override
protected void configure(AuthenticationManagerBuilder auth) throws Exception {
    auth.userDetailsService(myService).passwordEncoder(encoder());
}
```

Becomes a `UserDetailsService` bean (Spring auto-wires it into the global `AuthenticationManager`):

```java
@Bean
public UserDetailsService userDetailsService() {
    return myService;
}

@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
}
```

If the project needs to expose the `AuthenticationManager` (for `/login` endpoints or `AuthenticationManager.authenticate(...)` calls), get it from `AuthenticationConfiguration`:

```java
@Bean
public AuthenticationManager authenticationManager(AuthenticationConfiguration cfg) throws Exception {
    return cfg.getAuthenticationManager();
}
```

## Method security

| Old | New |
|---|---|
| `@EnableGlobalMethodSecurity(prePostEnabled = true)` | `@EnableMethodSecurity` (prePost is on by default) |
| `@EnableGlobalMethodSecurity(securedEnabled = true)` | `@EnableMethodSecurity(securedEnabled = true)` |
| `@EnableGlobalMethodSecurity(jsr250Enabled = true)` | `@EnableMethodSecurity(jsr250Enabled = true)` |

`@PreAuthorize`, `@PostAuthorize`, `@Secured`, `@RolesAllowed` are unchanged at the use site.

## CSRF defaults

CSRF protection is enabled by default. For stateless REST APIs the conventional disable is:

```java
http.csrf(csrf -> csrf.disable());
```

This is a deliberate, security-relevant choice — if the existing code did not disable CSRF and the project is a stateful web app, don't add `.disable()` just to make a test pass. Ask the developer.

## When to pause and ask

A custom Security config that uses any of these is **ambiguous**:

- Multiple `WebSecurityConfigurerAdapter` subclasses with `@Order` (could become multiple ordered `SecurityFilterChain` beans, but the matcher boundaries need to be explicit).
- Custom `AuthenticationProvider` subclasses (the registration path changed).
- Custom filters added via `addFilterBefore`/`addFilterAfter` (still works, but constructor signatures may have changed).
- OAuth2 resource server / client config (DSL changed shape, but the most common cases have direct equivalents).

Present the file, the original pattern, and 2–3 migration options before editing.
