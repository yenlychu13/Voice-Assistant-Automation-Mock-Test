# 🎙️ Voice Assistant Integration Test Architecture

This repository contains **sanitized integration test cases** demonstrating my design patterns and approach for testing Voice Assistant interactions, hardware state controls, and media playback on Apple platforms.

Because the original codebases are proprietary, internal dependencies, frameworks, and hardware APIs have been abstracted into generic interfaces.

---

## 🛠️ Testing Philosophy & Key Patterns

These examples highlight four core principles I apply when writing automated integration test suites for voice-driven platforms:

1. **Fluent Test Runner Pattern (`AssistantTestRunner`)**
   - Abstracts complex voice interactions, UI snippet assertions, and playback checks into chainable, declarative calls for maximum readability and maintenance.
2. **Hardware & System State Verification**
   - Demonstrates setting baseline device states (e.g., volume, initial conditions) and asserting physical/system side-effects after voice command execution.
3. **Guaranteed Test Isolation & Teardown**
   - Uses `addTeardownBlock` and isolated mock data stores (`MockCalendarStore`) to reset application state automatically after execution, eliminating flaky test cascading across CI pipelines.
4. **Deterministic State & Environment Guards**
   - **Time Offsets:** Seeds calendar events at explicit future times (`+5 hours`) to avoid overlapping edge-case failures during test execution.
   - **CI Guards (`XCTSkipIf`):** Gracefully skips execution when required environmental preconditions (such as active subscriptions) are absent in CI sandbox runs.

---

## 💻 Test Suite Overview (`AssistantTests.swift`)

The suite covers three real-world voice assistant integration workflows:

* **Case 1: Calendar Query & UI Snippet Verification (`test_query_upcoming_calendar_event`)**
  - Tests seeding dynamic calendar data, issuing a localized voice query, and verifying that the resulting UI snippet accurately reflects the event with guaranteed teardown.
* **Case 2: Media Playback Automation (`test_playback_with_voice_command`)**
  - Tests triggering media playback via voice command, handling localized search arguments, and verifying player state while ensuring subscription preconditions are met.
* **Case 3: System Settings (`test_set_system_volume_via_voice`)**
  - Tests hardware/system-level side effects by initializing baseline system volume, executing parameterized voice setting commands (`"Set volume to 80%"`), and asserting post-execution hardware state updates.

---

## 🧰 Tech Stack & Concepts

- **Language:** Swift 5+
- **Framework:** XCTest
- **Patterns:** Builder / Fluent API, Mock Repositories, System State Verification, Environment Guards, Localization Resolution