import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            TodoListView()
                .tabItem {
                    Label("To-Do", systemImage: "checklist")
                }

            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }

            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
