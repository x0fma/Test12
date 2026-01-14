import Foundation
import Observation

@Observable
class TodoStore {
    var items: [TodoItem] = [] {
        didSet {
            save()
        }
    }

    private let saveKey = "TodoItems"

    init() {
        load()
    }

    func addItem(title: String) {
        let newItem = TodoItem(title: title)
        items.append(newItem)
    }

    func toggleCompletion(for item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }

    func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) {
            items = decoded
        }
    }
}
