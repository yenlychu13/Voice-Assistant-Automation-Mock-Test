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
