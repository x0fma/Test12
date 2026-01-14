import SwiftUI

struct ProfileView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false

    var body: some View {
        NavigationStack {
            List {
                // Profile Header Section
                Section {
                    HStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.blue.gradient)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("John Doe")
                                .font(.title2)
                                .fontWeight(.semibold)

                            Text("john.doe@example.com")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }
                    .padding(.vertical, 8)
                }

                // Account Section
                Section("Account") {
                    NavigationLink {
                        Text("Edit Profile")
                    } label: {
                        Label("Edit Profile", systemImage: "person.fill")
                    }

                    NavigationLink {
                        Text("Change Password")
                    } label: {
                        Label("Change Password", systemImage: "key.fill")
                    }

                    NavigationLink {
                        Text("Privacy Settings")
                    } label: {
                        Label("Privacy", systemImage: "lock.fill")
                    }
                }

                // Preferences Section
                Section("Preferences") {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Notifications", systemImage: "bell.fill")
                    }

                    Toggle(isOn: $darkModeEnabled) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }

                    NavigationLink {
                        Text("Language Settings")
                    } label: {
                        Label("Language", systemImage: "globe")
                    }
                }

                // Support Section
                Section("Support") {
                    NavigationLink {
                        Text("Help Center")
                    } label: {
                        Label("Help Center", systemImage: "questionmark.circle.fill")
                    }

                    NavigationLink {
                        Text("Contact Us")
                    } label: {
                        Label("Contact Us", systemImage: "envelope.fill")
                    }

                    NavigationLink {
                        Text("About")
                    } label: {
                        Label("About", systemImage: "info.circle.fill")
                    }
                }

                // Sign Out Section
                Section {
                    Button(role: .destructive) {
                        // Sign out action
                    } label: {
                        HStack {
                            Spacer()
                            Label("Sign Out", systemImage: "arrow.right.square.fill")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
