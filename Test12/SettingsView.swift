import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var soundEnabled = true
    @State private var hapticsEnabled = true
    @State private var autoPlayVideos = false
    @State private var dataSync = true
    @State private var selectedAppearance = "System"

    let appearanceOptions = ["Light", "Dark", "System"]

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
                    Picker("Theme", selection: $selectedAppearance) {
                        ForEach(appearanceOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Notifications Section
                Section {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Push Notifications", systemImage: "bell.fill")
                    }

                    Toggle(isOn: $soundEnabled) {
                        Label("Sound", systemImage: "speaker.wave.2.fill")
                    }
                    .disabled(!notificationsEnabled)

                    Toggle(isOn: $hapticsEnabled) {
                        Label("Haptic Feedback", systemImage: "hand.tap.fill")
                    }
                } header: {
                    Text("Notifications & Feedback")
                } footer: {
                    Text("Control how you receive notifications and feedback from the app")
                }

                // Media Section
                Section("Media") {
                    Toggle(isOn: $autoPlayVideos) {
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
                    Toggle(isOn: $dataSync) {
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
}
