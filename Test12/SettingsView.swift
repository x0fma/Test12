import SwiftUI

struct SettingsView: View {
    @Environment(SettingsStore.self) private var settingsStore

    // Get app version from bundle
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }

    var body: some View {
        NavigationStack {
            List {
                // Appearance Section
                Section("Appearance") {
                    Picker("Theme", selection: $settingsStore.selectedTheme) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Text(theme.displayName).tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Notifications Section
                Section {
                    Toggle(isOn: $settingsStore.notificationsEnabled) {
                        Label("Push Notifications", systemImage: "bell.fill")
                    }

                    Toggle(isOn: $settingsStore.soundEnabled) {
                        Label("Sound", systemImage: "speaker.wave.2.fill")
                    }
                    .disabled(!settingsStore.notificationsEnabled)

                    Toggle(isOn: $settingsStore.hapticsEnabled) {
                        Label("Haptic Feedback", systemImage: "hand.tap.fill")
                    }
                } header: {
                    Text("Notifications & Feedback")
                } footer: {
                    Text("Control how you receive notifications and feedback from the app")
                }

                // Media Section
                Section("Media") {
                    Toggle(isOn: $settingsStore.autoPlayVideos) {
                        Label("Auto-play Videos", systemImage: "play.circle.fill")
                    }

                    NavigationLink {
                        Text("Storage Management")
                    } label: {
                        Label("Storage", systemImage: "externaldrive.fill")
                    }
                }

                // Data & Privacy Section
                Section("Data & Privacy") {
                    Toggle(isOn: $settingsStore.dataSyncEnabled) {
                        Label("Sync Data", systemImage: "arrow.triangle.2.circlepath")
                    }

                    NavigationLink {
                        Text("Privacy Settings")
                    } label: {
                        Label("Privacy", systemImage: "lock.shield.fill")
                    }

                    NavigationLink {
                        Text("Data Usage")
                    } label: {
                        Label("Data Usage", systemImage: "chart.bar.fill")
                    }
                }

                // General Section
                Section("General") {
                    NavigationLink {
                        Text("Language & Region")
                    } label: {
                        Label("Language", systemImage: "globe")
                    }

                    NavigationLink {
                        Text("Accessibility")
                    } label: {
                        Label("Accessibility", systemImage: "accessibility")
                    }
                }

                // About Section
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(appVersion)
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Build")
                        Spacer()
                        Text(buildNumber)
                            .foregroundStyle(.secondary)
                    }

                    NavigationLink {
                        Text("Terms of Service")
                    } label: {
                        Label("Terms of Service", systemImage: "doc.text.fill")
                    }

                    NavigationLink {
                        Text("Privacy Policy")
                    } label: {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                    }

                    NavigationLink {
                        Text("Licenses")
                    } label: {
                        Label("Open Source Licenses", systemImage: "doc.plaintext.fill")
                    }
                }

                // Clear Cache Section
                Section {
                    Button(role: .destructive) {
                        // Clear cache action
                    } label: {
                        HStack {
                            Spacer()
                            Label("Clear Cache", systemImage: "trash.fill")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .environment(SettingsStore())
}
