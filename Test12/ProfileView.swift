import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.purple)

                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Your account settings")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
