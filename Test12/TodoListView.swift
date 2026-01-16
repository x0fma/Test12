import SwiftUI

struct TodoListView: View {
    @Environment(TodoStore.self) private var store
    @State private var newTodoTitle = ""
    @FocusState private var isInputFocused: Bool
    @State private var showConfetti = false

    var body: some View {
        NavigationStack {
            ZStack {
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
                                let wasCompleted = item.isCompleted
                                store.toggleCompletion(for: item)

                                // Show confetti only when marking as complete
                                if !wasCompleted {
                                    showConfetti = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        showConfetti = false
                                    }
                                }
                            }
                        }
                        .onDelete(perform: store.deleteItems)
                    }
                    .listStyle(.plain)
                }
            }

            // Confetti overlay
            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
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

    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isAnimating = true
                }

                // Haptic feedback
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()

                onToggle()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isAnimating = false
                }
            }) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(item.isCompleted ? .green : .gray)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .rotationEffect(.degrees(isAnimating && item.isCompleted ? 360 : 0))
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.body)
                    .strikethrough(item.isCompleted)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)
                    .animation(.easeInOut(duration: 0.2), value: item.isCompleted)

                HStack(spacing: 4) {
                    Text(item.isCompleted && item.completedAt != nil ? "Completed " : "Created ")
                        .font(.caption)
                        .foregroundStyle(.tertiary)

                    if item.isCompleted, let completedDate = item.completedAt {
                        Text(completedDate, style: .relative)
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    } else {
                        Text(item.createdAt, style: .relative)
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// Confetti celebration effect
struct ConfettiView: View {
    @State private var animate = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<50, id: \.self) { index in
                    ConfettiPiece(geometry: geometry)
                        .offset(y: animate ? geometry.size.height + 100 : -100)
                        .animation(
                            .linear(duration: Double.random(in: 1.5...2.5))
                            .delay(Double.random(in: 0...0.3)),
                            value: animate
                        )
                }
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct ConfettiPiece: View {
    let geometry: GeometryProxy

    @State private var xPosition = CGFloat.random(in: 0...1)
    @State private var rotation = Double.random(in: 0...360)
    @State private var scale = CGFloat.random(in: 0.5...1.5)

    let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink, .mint]
    let shapes: [String] = ["circle.fill", "star.fill", "heart.fill", "sparkle"]

    var body: some View {
        Image(systemName: shapes.randomElement() ?? "circle.fill")
            .foregroundStyle(colors.randomElement() ?? .blue)
            .font(.system(size: 12 * scale))
            .rotationEffect(.degrees(rotation))
            .position(x: xPosition * geometry.size.width, y: 0)
    }
}

#Preview {
    TodoListView()
        .environment(TodoStore())
}
