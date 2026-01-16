import Foundation
import Observation

@Observable
class UserStore {
    var users: [User] = [] {
        didSet {
            save()
        }
    }

    private let saveKey = "Users"

    init() {
        load()
        // Create mock data if empty
        if users.isEmpty {
            createMockUsers()
        }
    }

    func addUser(name: String, email: String) {
        let newUser = User(name: name, email: email)
        users.append(newUser)
    }

    func updateUserTodoCount(userId: UUID, count: Int) {
        if let index = users.firstIndex(where: { $0.id == userId }) {
            users[index].todoCount = count
        }
    }

    // Statistics computed properties
    var totalUsers: Int {
        users.count
    }

    var activeUsers: Int {
        users.filter { $0.todoCount > 0 }.count
    }

    var newUsers: Int {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return users.filter { $0.createdAt >= sevenDaysAgo }.count
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([User].self, from: data) {
            users = decoded
        }
    }

    private func createMockUsers() {
        let now = Date()
        let calendar = Calendar.current

        // Mix of old and new users with varying todo counts
        let mockUsers = [
            User(name: "Alice Johnson", email: "alice@example.com",
                 createdAt: calendar.date(byAdding: .day, value: -30, to: now) ?? now,
                 todoCount: 12),
            User(name: "Bob Smith", email: "bob@example.com",
                 createdAt: calendar.date(byAdding: .day, value: -25, to: now) ?? now,
                 todoCount: 8),
            User(name: "Carol Davis", email: "carol@example.com",
                 createdAt: calendar.date(byAdding: .day, value: -20, to: now) ?? now,
                 todoCount: 15),
            User(name: "David Wilson", email: "david@example.com",
                 createdAt: calendar.date(byAdding: .day, value: -15, to: now) ?? now,
                 todoCount: 5),
            User(name: "Emma Brown", email: "emma@example.com",
                 createdAt: calendar.date(byAdding: .day, value: -10, to: now) ?? now,
                 todoCount: 20),
            User(name: "Frank Miller", email: "frank@example.com",
                 createdAt: calendar.date(byAdding: .day, value: -5, to: now) ?? now,
                 todoCount: 3),
            User(name: "Grace Lee", email: "grace@example.com",
                 createdAt: calendar.date(byAdding: .day, value: -3, to: now) ?? now,
                 todoCount: 7),
            User(name: "Henry Taylor", email: "henry@example.com",
                 createdAt: calendar.date(byAdding: .day, value: -2, to: now) ?? now,
                 todoCount: 0),
            User(name: "Iris Chen", email: "iris@example.com",
                 createdAt: calendar.date(byAdding: .day, value: -1, to: now) ?? now,
                 todoCount: 4),
            User(name: "Jack Martinez", email: "jack@example.com",
                 createdAt: now,
                 todoCount: 0)
        ]

        users = mockUsers
    }
}
