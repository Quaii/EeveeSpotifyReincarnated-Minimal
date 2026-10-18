import SwiftUI
import UIKit

struct EeveeSettingsView: View {
    let navigationController: UINavigationController

    @State private var hasShownCommonIssuesTip = UserDefaults.hasShownCommonIssuesTip

    private static let groups: [SettingsGroup] = [
        SettingsGroup(key: "settings_group_listening", entries: [
            SettingsEntry(key: "patching", icon: "hammer.fill", color: .orange) { AnyView(EeveePatchingSettingsView()) },
            SettingsEntry(key: "sponsorblock", icon: "forward.end.fill", color: .red) { AnyView(SponsorBlockSettingsView()) },
        ]),
        SettingsGroup(key: "settings_group_looks", entries: [
            SettingsEntry(key: "appIcon", icon: "app.badge.fill", color: .pink) { AnyView(EeveeAppIconPickerView()) },
        ]),
        SettingsGroup(key: "settings_group_advanced", entries: [
            SettingsEntry(key: "experiments", icon: "sparkle", color: .purple) { AnyView(EeveeExperimentsSettingsView()) },
            SettingsEntry(key: "miscellaneous", icon: "ellipsis.circle.fill", color: .gray) { AnyView(EeveeMiscellaneousSettingsView()) },
            SettingsEntry(key: "debug", icon: "ant.fill", color: .green) { AnyView(EeveeDebugSettingsView()) },
            SettingsEntry(key: "troubleshooting", icon: "wrench.and.screwdriver.fill", color: .blue) { AnyView(EeveeTroubleshootingSettingsView()) },
        ]),
    ]

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        SettingsNavigator.navigationController = navigationController
    }

    var body: some View {
        List {
            Section {
                SettingsHero()
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())

            EeveeSettingsVersionView()

            if !hasShownCommonIssuesTip {
                CommonIssuesTipView(
                    onDismiss: {
                        hasShownCommonIssuesTip = true
                        UserDefaults.hasShownCommonIssuesTip = true
                    }
                )
            }

            ForEach(Self.groups) { group in
                SettingsGroupSection(group: group) { entry in
                    SettingsNavigator.push(entry.make(), title: entry.key.localized)
                }
            }

            SpacerView()
        }
        .eeveeSettingsStyle()

        .animation(.default, value: hasShownCommonIssuesTip)

        .onAppear {
            WindowHelper.shared.overrideUserInterfaceStyle(.dark)
        }
    }
}
