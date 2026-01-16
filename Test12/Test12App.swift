import SwiftUI

@main
struct Test12App: App {
    @State private var todoStore = TodoStore()
    @State private var userStore = UserStore()
    @State private var settingsStore = SettingsStore()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(todoStore)
                .environment(userStore)
                .environment(settingsStore)
                .preferredColorScheme(settingsStore.selectedTheme.colorScheme)
        }
    }
}
