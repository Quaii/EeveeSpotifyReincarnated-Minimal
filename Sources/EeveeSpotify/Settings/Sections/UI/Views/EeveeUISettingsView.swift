import SwiftUI
import UIKit

struct EeveeUISettingsView: View {
    var body: some View {
        List {
            Section {
                Toggle(
                    "dark_popups".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.darkPopUps },
                        set: { UserDefaults.darkPopUps = $0 }
                    )
                )
            }

            SpacerView()
        }

        .eeveeSettingsStyle()
    }
}
