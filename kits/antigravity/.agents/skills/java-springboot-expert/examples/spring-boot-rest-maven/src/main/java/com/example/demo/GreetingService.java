package com.example.demo;

import org.springframework.stereotype.Service;

@Service
public class GreetingService {

  public GreetingResponse greet(String name) {
    String safeName = (name == null || name.isBlank()) ? "world" : name.trim();
    return new GreetingResponse("Hello, " + safeName + "!");
  }
}
