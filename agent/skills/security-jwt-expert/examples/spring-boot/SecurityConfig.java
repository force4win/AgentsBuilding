/*
 * Ejemplo Spring Boot (Spring Security) — conceptual (adaptar a tu versión).
 * Objetivo: validar issuer/audience/alg y mapear scopes a authorities.
 *
 * Requiere: spring-boot-starter-oauth2-resource-server
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

  @Bean
  SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    http
      .csrf(csrf -> csrf.disable()) // OJO: si usas cookies, CSRF debe estar habilitado y configurado.
      .authorizeHttpRequests(auth -> auth
        .requestMatchers("/public/**").permitAll()
        .anyRequest().authenticated()
      )
      .oauth2ResourceServer(oauth2 -> oauth2
        .jwt(jwt -> jwt
          .decoder(jwtDecoder())
        )
      );

    return http.build();
  }

  @Bean
  JwtDecoder jwtDecoder() {
    // Recomendado: JWK Set URI (JWKS) con rotación y caching
    String jwkSetUri = "https://auth.tu-dominio.com/.well-known/jwks.json";
    NimbusJwtDecoder decoder = NimbusJwtDecoder.withJwkSetUri(jwkSetUri).build();

    OAuth2TokenValidator<Jwt> withIssuer = JwtValidators.createDefaultWithIssuer("https://auth.tu-dominio.com");
    OAuth2TokenValidator<Jwt> audienceValidator = new AudienceValidator("https://api.tu-dominio.com");
    OAuth2TokenValidator<Jwt> validator = new DelegatingOAuth2TokenValidator<>(withIssuer, audienceValidator);

    decoder.setJwtValidator(validator);

    // Importante: restringir algoritmos a los esperados (RS256/ES256) según configuración de Nimbus.
    return decoder;
  }
}
