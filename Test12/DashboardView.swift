import SwiftUI

struct DashboardView: View {
    @Environment(UserStore.self) private var userStore
    @Environment(TodoStore.self) private var todoStore

    @State private var isRefreshing = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.blue)

                        Text("Admin Dashboard")
                            .font(.title)
                            .fontWeight(.bold)

                        Text("Overview of platform statistics")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top)

                    // User Metrics Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("User Metrics")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 4)

                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            StatCard(
                                title: "Total Users",
                                value: "\(userStore.totalUsers)",
                                icon: "person.3.fill",
                                color: .blue
                            )

                            StatCard(
                                title: "Active Users",
                                value: "\(userStore.activeUsers)",
                                icon: "person.fill.checkmark",
                                color: .green
                            )

                            StatCard(
                                title: "New Users",
                                value: "\(userStore.newUsers)",
                                icon: "person.badge.plus",
                                color: .orange
                            )

                            StatCard(
                                title: "Inactive Users",
                                value: "\(userStore.totalUsers - userStore.activeUsers)",
                                icon: "person.fill.xmark",
                                color: .gray
                            )
                        }
                    }

                    // Todo Metrics Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Todo Metrics")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 4)

                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            StatCard(
                                title: "Total Todos",
                                value: "\(totalTodos)",
                                icon: "list.bullet",
                                color: .purple
                            )

                            StatCard(
                                title: "Completed",
                                value: "\(completedTodos)",
                                icon: "checkmark.circle.fill",
                                color: .green
                            )

                            StatCard(
                                title: "Pending",
                                value: "\(pendingTodos)",
                                icon: "circle",
                                color: .orange
                            )

                            StatCard(
                                title: "Completion Rate",
                                value: completionRate,
                                icon: "chart.line.uptrend.xyaxis",
                                color: .blue
                            )
                        }
                    }

                    // Analytics Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today's Analytics")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 4)

                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            StatCard(
                                title: "Completed Today",
                                value: "\(completedToday)",
                                icon: "calendar.badge.checkmark",
                                color: .mint
                            )

                            StatCard(
                                title: "Avg Time to Complete",
                                value: averageCompletionTime,
                                icon: "clock.fill",
                                color: .indigo
                            )

                            StatCard(
                                title: "Productivity Score",
                                value: productivityScore,
                                icon: "star.fill",
                                color: .yellow
                            )

                            StatCard(
                                title: "Longest Streak",
                                value: "\(longestStreak) days",
                                icon: "flame.fill",
                                color: .red
                            )
                        }
                    }

                    // Last updated
                    Text("Pull to refresh")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .padding(.top, 8)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Dashboard")
            .refreshable {
                await refresh()
            }
        }
    }

    // Computed properties for stats
    private var totalTodos: Int {
        todoStore.items.count
    }

    private var completedTodos: Int {
        todoStore.items.filter { $0.isCompleted }.count
    }

    private var pendingTodos: Int {
        todoStore.items.filter { !$0.isCompleted }.count
    }

    private var completionRate: String {
        guard totalTodos > 0 else { return "0%" }
        let rate = Double(completedTodos) / Double(totalTodos) * 100
        return String(format: "%.0f%%", rate)
    }

    // Analytics computed properties
    private var completedToday: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return todoStore.items.filter { item in
            guard let completedAt = item.completedAt else { return false }
            return calendar.isDate(completedAt, inSameDayAs: today)
        }.count
    }

    private var averageCompletionTime: String {
        let completedItems = todoStore.items.filter { $0.isCompleted && $0.completedAt != nil }
        guard !completedItems.isEmpty else { return "N/A" }

        let totalMinutes = completedItems.reduce(0.0) { total, item in
            guard let completedAt = item.completedAt else { return total }
            let timeInterval = completedAt.timeIntervalSince(item.createdAt)
            return total + (timeInterval / 60.0) // Convert to minutes
        }

        let avgMinutes = totalMinutes / Double(completedItems.count)

        if avgMinutes < 60 {
            return String(format: "%.0f min", avgMinutes)
        } else if avgMinutes < 1440 { // Less than 24 hours
            return String(format: "%.1f hrs", avgMinutes / 60)
        } else {
            return String(format: "%.1f days", avgMinutes / 1440)
        }
    }

    private var productivityScore: String {
        guard totalTodos > 0 else { return "0" }

        // Score based on completion rate and speed
        let completionFactor = Double(completedTodos) / Double(totalTodos)
        let todayFactor = completedToday > 0 ? 1.2 : 1.0

        let score = Int((completionFactor * 100) * todayFactor)
        return "\(min(score, 100))"
    }

    private var longestStreak: Int {
        let calendar = Calendar.current
        let completedItems = todoStore.items
            .filter { $0.isCompleted && $0.completedAt != nil }
            .sorted { ($0.completedAt ?? Date()) > ($1.completedAt ?? Date()) }

        guard !completedItems.isEmpty else { return 0 }

        var currentStreak = 1
        var maxStreak = 1
        var previousDate = completedItems.first?.completedAt

        for item in completedItems.dropFirst() {
            guard let currentDate = item.completedAt,
                  let prevDate = previousDate else { continue }

            let daysDifference = calendar.dateComponents([.day], from: currentDate, to: prevDate).day ?? 0

            if daysDifference == 1 {
                currentStreak += 1
                maxStreak = max(maxStreak, currentStreak)
            } else if daysDifference > 1 {
                currentStreak = 1
            }

            previousDate = currentDate
        }

        return maxStreak
    }

    private func refresh() async {
        isRefreshing = true
        // Simulate a brief refresh delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        isRefreshing = false
    }
}

#Preview {
    DashboardView()
        .environment(UserStore())
        .environment(TodoStore())
}
