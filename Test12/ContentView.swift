import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)

            Text("Hello, World!")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Test12")
                .font(.title2)
                .foregroundColor(.secondary)

            Text("Built with Vibuilder")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
