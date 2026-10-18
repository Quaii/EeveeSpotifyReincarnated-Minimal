import SwiftUI

struct EeveeSettingsVersionView: View {
    @State private var latestVersion: String?
    @State private var sections: [EeveeContributorSection] = []
    @State private var sheetTarget: [String]?

    private var allUsernames: [String] {
        sections.flatMap(\.contributors).flatMap(\.usernames)
    }

    private func loadVersion() async throws {
        let release = try await GitHubHelper.shared.getLatestRelease()
        // Handle tag formats: "6.4.3", "v6.4.3", or "swift6.4.3"
        var version = release.tagName
        if version.hasPrefix("swift") {
            version = String(version.dropFirst(5)) // swift6.4.3 -> 6.4.3
        } else if version.hasPrefix("v") {
            version = String(version.dropFirst(1)) // v6.4.3 -> 6.4.3
        }
        latestVersion = version
    }

    private func loadSections() async {
        sections = (try? await GitHubHelper.shared.getEeveeContributorSections()) ?? []
    }

    private func openSheet(for username: String) {
        // Burger passes an empty array: present the sheet without a scroll target.
        let contributor = sections.flatMap(\.contributors).first { $0.usernames.contains(username) }
        sheetTarget = contributor?.usernames ?? []
    }

    private var isUpdateAvailable: Bool {
        guard let latestVersion = latestVersion else { return false }
        return isNewerVersion(latestVersion, than: EeveeSpotify.version)
    }

    private func isNewerVersion(_ version1: String, than version2: String) -> Bool {
        let v1Components = version1.split(separator: ".").compactMap { Int($0) }
        let v2Components = version2.split(separator: ".").compactMap { Int($0) }

        // Compare major, minor, patch
        for i in 0..<max(v1Components.count, v2Components.count) {
            let v1 = i < v1Components.count ? v1Components[i] : 0
            let v2 = i < v2Components.count ? v2Components[i] : 0

            if v1 > v2 { return true }  // version1 is newer
            if v1 < v2 { return false } // version1 is older
        }

        return false // versions are equal
    }

    var body: some View {
        Group {
            Section {
                if isUpdateAvailable {
                    Link(
                        "update_available".localized,
                        destination: URL(string: "https://github.com/jaydenjcpy/EeveeSpotifyReincarnated/releases")!
                    )
                }
            } footer: {
                if latestVersion == nil {
                    HStack(spacing: 10) {
                        ProgressView()
                        Text("checking_for_update".localized)
                    }
                }
            }

            if !allUsernames.isEmpty {
                // Full-bleed strip: spans the same left/right edges as the group
                // panes, scrolls horizontally, burger opens the sheet at the end.
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(allUsernames, id: \.self) { username in
                                Button {
                                    openSheet(for: username)
                                } label: {
                                    ImageView(urlString: "https://github.com/\(username).png")
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.plain)
                            }

                            Button {
                                sheetTarget = []
                            } label: {
                                Image(systemName: "line.3.horizontal")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                                    .frame(width: 40, height: 40)
                                    .background(Circle().fill(Color.gray.opacity(0.25)))
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 2)
                    }
                    .frame(height: 48)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }
        }
        .sheet(isPresented: Binding(
            get: { sheetTarget != nil },
            set: { if !$0 { sheetTarget = nil } }
        )) {
            EeveeContributorsSheetView(scrollTo: sheetTarget)
        }

        .animation(.default, value: latestVersion)
        .animation(.default, value: sections)

        .onAppear {
            Task {
                try await loadVersion()
                await loadSections()
            }
        }
    }
}
