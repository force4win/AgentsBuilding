package com.example.demo;

import jakarta.validation.constraints.NotBlank;

public record GreetingRequest(
    @NotBlank(message = "name es requerido")
    String name
) {}
