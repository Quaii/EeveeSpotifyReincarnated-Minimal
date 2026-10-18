import SwiftUI
import UIKit

struct EeveeDebugSettingsView: View {
    private func exportDebugLog() {
        guard let data = FileManager.default.contents(atPath: EeveeLog.path), !data.isEmpty else {
            PopUpHelper.showPopUp(message: "no_debug_log_found".localized, buttonText: "no_debug_log_found_ok".localized)
            return
        }
        let share = UIActivityViewController(activityItems: [URL(fileURLWithPath: EeveeLog.path)], applicationActivities: nil)
        if let popover = share.popoverPresentationController, let view = SettingsNavigator.navigationController?.view {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        }
        WindowHelper.shared.present(share)
    }

    private func clearDebugLog() {
        EeveeLog.clear()
        writeDebugLog("Log cleared by user")
        PopUpHelper.showPopUp(message: "debug_log_cleared".localized, buttonText: "debug_log_cleared_ok".localized)
    }

    var body: some View {
        List {
            Section(footer: Text("debug_section_footer".localized)) {
                Toggle(
                    "debug_logging".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.debugLoggingEnabled },
                        set: { UserDefaults.debugLoggingEnabled = $0 }
                    )
                )

                Button(action: exportDebugLog) {
                    SettingsLabel(title: "export_debug_log".localized, icon: "square.and.arrow.up", color: .blue)
                }
                Button(action: clearDebugLog) {
                    SettingsLabel(title: "clear_debug_log".localized, icon: "trash.fill", color: .gray)
                }
            }

            SpacerView()
        }
        .eeveeSettingsStyle()
    }
}
