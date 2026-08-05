import XCTest

final class AssistantTests: XCTestCase {

    // MARK: - Test 1: Calendar Query
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

        // 3. Seed test data deterministically (+5 hours out)
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
    
    // MARK: - Test 2: Media Playback
    func test_playback_with_voice_command() throws {
        // 1. Precondition Guard: Skip the test if subscription active state is missing
        try XCTSkipIf(
            !MockMusicPlayer.shared.isSubscriptionActive,
            "Active subscription required for media playback test."
        )

        // 2. Prepare localized test fixtures
        let artistName = Localizer.get("ARTIST_MILEY_CYRUS", table: "Music")
        let voiceCommand = Localizer.format("PLAY_X", table: "Music", args: artistName)

        // 3. Test scenario execution
        AssistantTestRunner(self)
            .sendVoiceCommand(voiceCommand)
            .assertPlaybackState(.playing)
            .assertCurrentArtist(contains: artistName)
            .finish()
    }

    // MARK: - Test 3: System Settings & Hardware Controls
    func test_set_system_volume_via_voice() throws {
        // 1. Set baseline state & record initial hardware volume level
        MockDeviceHardware.shared.setSystemVolume(toLevel: 25)
        let initialVolume = MockDeviceHardware.shared.currentSystemVolume

        // 2. Resolve localized voice command with dynamic integer arguments
        let voiceCommand = Localizer.format("SET_VOLUME_TO_PERCENT", table: "Settings", args: 80)

        // 3. Execute voice command flow
        AssistantTestRunner(self)
            .sendVoiceCommand(voiceCommand, origin: .homeButton)
            .finish()

        // 4. Verify system hardware state changed as expected
        let currentVolume = MockDeviceHardware.shared.currentSystemVolume
        XCTAssertEqual(
            currentVolume, 80,
            "System volume failed to update to 80%. Initial: \(initialVolume), Current: \(currentVolume)"
        )
    }
}