import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "magnifyingglass.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)

                Text("Explore")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Discover new content")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
            .navigationTitle("Explore")
        }
    }
}

#Preview {
    ExploreView()
}
