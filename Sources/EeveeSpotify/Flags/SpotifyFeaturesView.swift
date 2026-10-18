import SwiftUI

struct SpotifyFeaturesView: View {
    @State private var version = 0
    @State private var flagsDefault = FlagOverrides.areDefault(SpotifyFeaturesView.keys)

    private static let sections: [(header: String, rows: [(String, String)])] = [
        ("features_playback", [
            ("features_trim_silence", "ios-playbackcontrol-playbackspeed-impl.enable_trim_silence"),
        ]),
        ("features_library", [
            ("features_recents", "ios-feature-yourlibaryx.recents_enabled"),
            ("features_recents_sort", "ios-feature-yourlibaryx.recents_sort_order_enabled"),
            ("features_sort_playlists", "ios-feature-yourlibaryx.recently_updated_playlists_sort_enabled"),
            ("features_sort_artists", "ios-feature-yourlibaryx.recently_updated_artists_sort_enabled"),
            ("features_denser_rows", "ios-feature-yourlibaryx.denser_rows_enabled"),
            ("features_library_settings", "ios-feature-yourlibaryx.library_settings_enabled"),
            ("features_library_pro", "ios-feature-yourlibaryx.your_library_pro_enabled"),
            ("features_shake_random", "ios-feature-yourlibaryx.shake_to_random_enabled"),
        ]),
        ("features_lockscreen", [
            ("features_lock_like", "ios-feature-lockscreen.like_dislike_enabled"),
            ("features_lock_podcast_skip", "ios-feature-lockscreen.skip_button_on_podcasts"),
            ("features_lock_chapters", "ios-feature-lockscreen.enable_chapter_skip_controls"),
            ("features_lock_animated", "ios-feature-lockscreen.animated_artwork_enabled"),
        ]),
        ("features_sleep_timer", [
            ("features_sleep_fade", "ios-feature-sleeptimer.enable_fade_out"),
            ("features_sleep_one_minute", "ios-feature-sleeptimer.enable_one_minute_option"),
        ]),
        ("features_home", [
            ("features_dj_button", "ios-home-evopage-impl.idj_show_dj_button"),
            ("features_dj_badge", "ios-home-evopage-impl.dj_mdc_beta_badge_enabled"),
        ]),
        ("features_other", [
            ("features_local_files", "ios-feature-localfiles.documents_enabled"),
        ]),
    ]

    private static var keys: [String] { sections.flatMap { $0.rows.map(\.1) } }

    var body: some View {
        List {
            ForEach(Self.sections, id: \.header) { section in
                Section(header: Text(section.header.localized)) {
                    ForEach(section.rows, id: \.1) { FlagOverrideRow(title: $0.0.localized, key: $0.1) { version += 1 } }
                }
            }
            .id(version)

            SettingsResetSection(visible: !flagsDefault) {
                FlagOverrides.clear(Self.keys)
                version += 1
            }

            if RemoteFlags.needsRestart {
                Section {
                    Button(action: exitApplication) {
                        Text("restart_now".localized).fontWeight(.semibold).frame(maxWidth: .infinity)
                    }
                    .foregroundColor(EeveeTheme.accent)
                }
            }

            SpacerView()
        }
        .eeveeSettingsStyle()
        .onAppear(perform: refreshFlags)
        .onChange(of: version) { _ in refreshFlags() }
    }

    private func refreshFlags() {
        flagsDefault = FlagOverrides.areDefault(Self.keys)
    }
}
