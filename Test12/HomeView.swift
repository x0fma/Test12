import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
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
                    .foregroundColor(.tertiary)
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}
