package com.example.demo;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1")
public class GreetingController {

  private final GreetingService service;

  public GreetingController(GreetingService service) {
    this.service = service;
  }

  @GetMapping("/greeting")
  public ResponseEntity<GreetingResponse> greeting(@RequestParam(defaultValue = "world") String name) {
    return ResponseEntity.ok(service.greet(name));
  }

  @PostMapping("/greeting")
  public ResponseEntity<GreetingResponse> greetingPost(@Valid @RequestBody GreetingRequest request) {
    return ResponseEntity.ok(service.greet(request.name()));
  }
}
