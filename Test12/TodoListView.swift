import SwiftUI

struct TodoListView: View {
    @State private var store = TodoStore()
    @State private var newTodoTitle = ""
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Input section
                HStack {
                    TextField("Add a new task...", text: $newTodoTitle)
                        .textFieldStyle(.roundedBorder)
                        .focused($isInputFocused)
                        .onSubmit(addTodo)

                    Button(action: addTodo) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    }
                    .disabled(newTodoTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()
                .background(Color(.systemGroupedBackground))

                // Todo list
                if store.items.isEmpty {
                    ContentUnavailableView(
                        "No Tasks",
                        systemImage: "checkmark.circle",
                        description: Text("Add a task to get started")
                    )
                } else {
                    List {
                        ForEach(store.items) { item in
                            TodoRowView(item: item) {
                                store.toggleCompletion(for: item)
                            }
                        }
                        .onDelete(perform: store.deleteItems)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("To-Do List")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func addTodo() {
        let trimmedTitle = newTodoTitle.trimmingCharacters(in: .whitespaces)
        guard !trimmedTitle.isEmpty else { return }

        store.addItem(title: trimmedTitle)
        newTodoTitle = ""
        isInputFocused = true
    }
}

struct TodoRowView: View {
    let item: TodoItem
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(item.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.body)
                    .strikethrough(item.isCompleted)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)

                Text(item.createdAt, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TodoListView()
}
