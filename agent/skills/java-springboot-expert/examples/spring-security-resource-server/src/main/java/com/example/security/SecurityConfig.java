/* CONCEPTUAL: adapta a tu versión de Spring Boot/Security. */
package com.example.security;

import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.OAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2TokenValidatorResult;
import org.springframework.security.oauth2.jwt.*;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableMethodSecurity
public class SecurityConfig {

  @Value("${app.security.audience}")
  private String audience;

  @Bean
  SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .csrf(csrf -> csrf.disable()) // OJO: si usas cookies para auth, configura CSRF apropiadamente.
        .authorizeHttpRequests(auth -> auth
            .requestMatchers("/public/**", "/actuator/health").permitAll()
            .anyRequest().authenticated()
        )
        .oauth2ResourceServer(oauth2 -> oauth2.jwt(Customizer.withDefaults()));

    return http.build();
  }

  /**
   * Valida audiencia además del issuer.
   * Boot configura el decoder por issuer-uri; aquí añadimos validator extra.
   */
  @Bean
  JwtDecoder jwtDecoder(JwtDecoderFactory<ClientRegistration> factory, NimbusJwtDecoderJwkSupport decoder) {
    // Nota: La firma/algoritmo se valida por Nimbus al usar JWKS del issuer.
    OAuth2TokenValidator<Jwt> audienceValidator = new AudienceValidator(audience);
    OAuth2TokenValidator<Jwt> withIssuer = JwtValidators.createDefaultWithIssuer(decoder.getJwtValidator().toString());
    OAuth2TokenValidator<Jwt> validator = new DelegatingOAuth2TokenValidator<>(audienceValidator);

    decoder.setJwtValidator(validator);
    return decoder;
  }

  static class AudienceValidator implements OAuth2TokenValidator<Jwt> {
    private final String audience;

    AudienceValidator(String audience) {
      this.audience = audience;
    }

    @Override
    public OAuth2TokenValidatorResult validate(Jwt jwt) {
      List<String> audiences = jwt.getAudience();
      if (audiences != null && audiences.contains(audience)) {
        return OAuth2TokenValidatorResult.success();
      }
      OAuth2Error err = new OAuth2Error("invalid_token", "Audience inválida", null);
      return OAuth2TokenValidatorResult.failure(err);
    }
  }
}
