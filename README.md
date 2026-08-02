# 🎙️ Voice Assistant Integration Test Architecture

This repository contains **sanitized integration test cases** demonstrating my design patterns and approach for testing Voice Assistant on Apple platforms. 

Because the original codebases are proprietary, internal dependencies, frameworks, and data sources have been abstracted into generic interfaces.

---

## 🛠️ Testing Philosophy & Key Patterns

These examples highlight three core principles I apply when writing automated test suites for voice-driven systems:

1. **Fluent Test Runner Pattern (`AssistantTestRunner`)**
   - Abstracts complex voice interaction, UI snippet assertions, and playback checks into chainable, declarative calls for maximum readability and ease of maintenance.
2. **Guaranteed Test Isolation & Teardown**
   - Uses `addTeardownBlock` and isolated mock data stores (`MockCalendarStore`) to reset application state automatically after execution, eliminating flaky test cascading across CI pipelines.
3. **Deterministic State & Environment Guards**
   - **Time Offsets:** Seeds calendar events at explicit future times (`+5 hours`) to avoid overlapping edge-case failures during test execution.
   - **CI Guards (`XCTSkipIf`):** Gracefully skips execution when required environmental preconditions (such as active subscriptions) are absent in CI sandbox runs.

---

## 💻 Test Suite Overview (`AssistantTests.swift`)

The suite covers two distinct real-world voice assistant integration workflows:

* **Case 1: Calendar Query & UI Snippet Verification (`test_query_upcoming_calendar_event`)**
  - Tests seeding dynamic calendar data, issuing a localized voice query, and verifying that the resulting UI snippet accurately reflects the event.
* **Case 2: Media Playback Automation (`test_playback_with_voice_command`)**
  - Tests triggering media playback via voice command, handling localized search arguments, and verifying player state while ensuring subscription preconditions are met.

---

## 🧰 Tech Stack & Concepts

- **Language:** Swift 5+
- **Framework:** XCTest
- **Patterns:** Builder / Fluent API, Mock Repositories, Environment Guards, Localization Resolution
