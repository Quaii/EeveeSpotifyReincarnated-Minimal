import SwiftUI

struct ContributorRow: View {
    let contributor: EeveeContributor

    var body: some View {
        if contributor.usernames.count > 1 {
            // Multiple main contributors: inline [pfp] name & [pfp] name
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    ForEach(Array(contributor.usernames.enumerated()), id: \.offset) { index, username in
                        if index > 0 {
                            Text("&")
                                .font(.title3).bold()
                                .foregroundColor(.white)
                        }
                        HStack(spacing: 6) {
                            // Bigger pfp for multi-contributor
                            ImageView(urlString: "https://github.com/\(username).png")
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                            Text(nameFor(index: index, username: username))
                                .font(.title3).bold()
                                .foregroundColor(.white)
                        }
                    }
                }
                Text(contributor.roles.joined(separator: ", "))
                    .font(.body)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
        } else {
            // Single contributor: pfp on left, name + roles on right
            HStack(alignment: .center, spacing: 14) {
                // Bigger pfp for single contributor
                ImageView(urlString: "https://github.com/\(contributor.usernames[0]).png")
                    .frame(width: 52, height: 52)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(contributor.displayName ?? contributor.usernames[0])
                        .font(.title3).bold()
                        .foregroundColor(.white)

                    if let richRoles = contributor.richRoles {
                        ForEach(richRoles, id: \.name) { role in
                            HStack(spacing: 6) {
                                Text(role.name)
                                    .font(.body)
                                    .foregroundColor(.gray)

                                // Co-contributor: dot separator + bigger pfp + white name matching contributor style
                                if let coUsernames = role.coUsernames, !coUsernames.isEmpty {
                                    ForEach(Array(coUsernames.enumerated()), id: \.offset) { index, username in
                                        HStack(spacing: 6) {
                                            Text("·")
                                                .font(.body).bold()
                                                .foregroundColor(.white)
                                            ImageView(urlString: "https://github.com/\(username).png")
                                                .frame(width: 22, height: 22)
                                                .clipShape(Circle())
                                            Text(role.coDisplayNames?[safe: index] ?? username)
                                                .font(.body).bold()
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        HStack(spacing: 0) {
                            ForEach(Array(contributor.roles.enumerated()), id: \.offset) { index, role in
                                if index > 0 {
                                    Text(", ")
                                        .font(.body)
                                        .foregroundColor(.gray)
                                }
                                Text(role)
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
        }
    }

    private func nameFor(index: Int, username: String) -> String {
        guard let displayName = contributor.displayName else { return username }
        if contributor.usernames.count == 1 { return displayName }
        let parts = displayName.components(separatedBy: " & ")
        return index < parts.count ? parts[index] : username
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

private struct FullWidthSeparatorModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
        } else {
            content
        }
    }
}

struct EeveeContributorsSheetView: View {
    // First usernames of the contributor the sheet was opened from; the list
    // scrolls to its row once loaded.
    var scrollTo: [String]? = nil

    @State private var sections: [EeveeContributorSection] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @State private var didScrollToTarget = false

    var body: some View {
        NavigationView {
            contentView
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            WindowHelper.shared.dismissCurrentViewController()
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 15, weight: .semibold))
                        }
                    }
                }
                .onAppear {
                    loadContributors()
                }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if isLoading {
            ProgressView("Loading".uiKitLocalized)
        } else if let error = errorMessage {
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                Text("Failed to load contributors")
                    .font(.headline)
                Text(error)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Button("Retry") {
                    isLoading = true
                    errorMessage = nil
                    loadContributors()
                }
            }
        } else if sections.isEmpty {
            Text("No contributors found")
                .foregroundColor(.gray)
        } else {
            contributorsList
        }
    }

    private var contributorsList: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(sections, id: \.title) { section in
                    Section(header: Text(section.title)) {
                        let contributors = section.shuffled ? section.contributors.shuffled() : section.contributors
                        ForEach(contributors, id: \.usernames) { contributor in
                            ContributorRow(contributor: contributor)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .modifier(FullWidthSeparatorModifier())
                                .id(contributor.usernames)
                        }
                    }
                }
            }
            .onAppear { scrollToTarget(proxy) }
        }
    }

    private func scrollToTarget(_ proxy: ScrollViewProxy) {
        guard !didScrollToTarget, let target = scrollTo, !target.isEmpty else { return }
        let flattened = sections.flatMap { section in
            section.contributors.map { ($0.usernames, section.shuffled) }
        }
        // Shuffled sections change order per launch; only scroll when the
        // first occurrence is stable enough to be meaningful.
        if let match = flattened.first(where: { $0.0 == target && !$0.1 }) {
            withAnimation { proxy.scrollTo(match.0, anchor: .top) }
        }
        didScrollToTarget = true
    }

    private func loadContributors() {
        Task {
            do {
                sections = try await GitHubHelper.shared.getEeveeContributorSections()
            } catch {
                print("Failed to load contributors: \(error)")
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

