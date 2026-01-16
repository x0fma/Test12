import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var createdAt: Date
    var todoCount: Int

    init(id: UUID = UUID(), name: String, email: String, createdAt: Date = Date(), todoCount: Int = 0) {
        self.id = id
        self.name = name
        self.email = email
        self.createdAt = createdAt
        self.todoCount = todoCount
    }
}
