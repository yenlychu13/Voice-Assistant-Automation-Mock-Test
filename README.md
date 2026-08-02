# Voice-Assistant-Automation-Mock-Test
# 🧪 Swift Assistant & Media Integration Test Harness

[![Swift](https://img.shields.io/badge/Swift-5.9+-FA7343?style=flat&logo=swift&logoColor=white)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20macOS-blue?style=flat)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A lightweight, fluent integration testing architecture for Apple platform apps. This project demonstrates clean patterns for testing voice assistant queries, media playback, localized strings, and calendar event flows using **XCTest** with strong **test isolation** and **deterministic state management**.

---

## ✨ Key Features & Architecture Highlights

- **Fluent Test Runner Pattern:** Abstracts complex UI and voice interaction assertions into highly readable, chainable methods (`AssistantTestRunner`).
- **Test Environment Isolation:** Leverages `addTeardownBlock` and isolated mock data stores (`MockCalendarStore`) to eliminate side effects and guarantee test independence.
- **Deterministic Time Offset Strategies:** Handles time-sensitive calendar assertions by seeding future events with explicit time offsets to prevent flakiness in edge-case runs.
- **Dynamic Precondition Handling:** Integrates `XCTSkipIf` guards to gracefully skip tests when prerequisites (such as active subscriptions) are absent in the CI environment.
- **Localization-Aware Assertions:** Built-in pattern to dynamically resolve and verify localized string tables across multiple locales.

---

## 🛠 Tech Stack

- **Language:** Swift 5.9+
- **Frameworks:** XCTest, Foundation
- **Design Patterns:** Builder Pattern / Fluent Interface, Mock Repository, Teardown Isolation

---

## 💻 Code Examples

### 1. Calendar Voice Query Test with Teardown Isolation
Demonstrates deterministic event seeding (`+5 hours`), automatic data teardown, and UI snippet assertions:

```swift
func test_query_upcoming_calendar_event() throws {
    // 1. Prepare localized fixtures
    let eventTitle = Localizer.get("CALENDAR_EVENT_OPTOMETRIST", table: "Calendar")
    let voiceQuery = Localizer.get("QUERY_NEXT_OPTOMETRIST_APPOINTMENT", table: "Calendar")

    // 2. Setup isolated test environment
    if MockCalendarStore.allCalendars().isEmpty {
        MockCalendarStore.addDefaultCalendar()
    }
    MockCalendarStore.deleteAllEvents()

    // Clean up test data after execution to guarantee test isolation
    addTeardownBlock {
        MockCalendarStore.deleteAllEvents()
    }

    // 3. Seed test data deterministically (+5 hours out to avoid overlapping active events)
    let startDate = Date().addingTimeInterval(5 * 3600)
    let mockEvent = MockCalendarEvent(
        title: eventTitle,
        startDate: startDate,
        durationMinutes: 60
    )
    let createdEvent = MockCalendarStore.add(event: mockEvent)
    XCTAssertNotNil(createdEvent, "Failed to seed calendar event: \(eventTitle)")

    // 4. Execute voice input flow & assert UI snippet response via Fluent API
    AssistantTestRunner(self)
        .sendVoiceQuery(voiceQuery, origin: .homeButton)
        .assertUISnippetContains(elements: [eventTitle])
        .finish()
}
