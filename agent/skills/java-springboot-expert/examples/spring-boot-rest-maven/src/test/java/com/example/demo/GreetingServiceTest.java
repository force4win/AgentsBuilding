package com.example.demo;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class GreetingServiceTest {

  @Test
  void greet_trims_and_defaults() {
    GreetingService s = new GreetingService();
    assertThat(s.greet("  Ana  ").message()).isEqualTo("Hello, Ana!");
    assertThat(s.greet("   ").message()).isEqualTo("Hello, world!");
  }
}
