import SwiftUI
import UIKit

struct EeveeTroubleshootingSettingsView: View {
    @State private var isClearingData = false

    private func wipe(_ work: @escaping () -> Void) {
        isClearingData = true
        DispatchQueue.global(qos: .userInitiated).async {
            work()
            DispatchQueue.main.async { exitApplication() }
        }
    }

    // One guarded entry instead of two bare destructive buttons: pick the
    // reset kind in the sheet, so nothing runs from a mis-tap on the list.
    private func showResetMenu() {
        let sheet = UIAlertController(title: "reset_data".localized, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "reset_data".localized, style: .default) { _ in
            confirmDestructive(title: "reset_data".localized, message: "reset_data_description".localized, confirm: "reset_data".localized) {
                wipe { OfflineHelper.resetData(clearCaches: true) }
            }
        })
        sheet.addAction(UIAlertAction(title: "resetButtonTitle".localized, style: .destructive) { _ in
            confirmDestructive(title: "resetButtonTitle".localized, message: "resetFooter".localized, confirm: "resetButtonTitle".localized) {
                wipe { FullResetHelper.wipeSpotifyState() }
            }
        })
        sheet.addAction(UIAlertAction(title: "Cancel".uiKitLocalized, style: .cancel))
        WindowHelper.shared.present(sheet)
    }

    var body: some View {
        List {
            Section(footer: Text("reset_section_footer".localized)) {
                Button(action: showResetMenu) {
                    SettingsLabel(
                        title: "reset_section".localized,
                        subtitle: "reset_menu_subtitle".localized,
                        icon: "arrow.counterclockwise",
                        color: .orange,
                        chevron: true
                    )
                }
            }
            .disabled(isClearingData)

            SpacerView()
        }
        .eeveeSettingsStyle()
        .animation(.default, value: isClearingData)
    }
}
