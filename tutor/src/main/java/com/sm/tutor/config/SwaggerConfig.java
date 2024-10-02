package com.sm.tutor.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import java.util.ArrayList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;

@Configuration
public class SwaggerConfig {

  private final MappingJackson2HttpMessageConverter converter;

  @Autowired
  public SwaggerConfig(MappingJackson2HttpMessageConverter converter) {
    this.converter = converter;
    var supportedMediaTypes = new ArrayList<>(converter.getSupportedMediaTypes());
    supportedMediaTypes.add(new MediaType("application", "octet-stream"));
    converter.setSupportedMediaTypes(supportedMediaTypes);
  }

  @Bean
  public OpenAPI openAPI() {
    String jwtScheme = "bearerAuth";
    SecurityRequirement securityRequirement = new SecurityRequirement().addList(jwtScheme);
    Components components = new Components().addSecuritySchemes(jwtScheme, new SecurityScheme()
        .name(jwtScheme)
        .type(SecurityScheme.Type.HTTP)
        .scheme("bearer")
        .bearerFormat("JWT")
    );
    return new OpenAPI()
        .components(components)
        .info(apiInfo())
        .addSecurityItem(securityRequirement);
  }

  private Info apiInfo() {
    return new Info()
        .title("API Test")
        .description("Let's practice Swagger UI")
        .version("1.0.0");
  }
}
