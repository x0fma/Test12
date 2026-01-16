import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.primary)

                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    VStack(spacing: 16) {
        StatCard(
            title: "Total Users",
            value: "1,234",
            icon: "person.3.fill",
            color: .blue
        )

        StatCard(
            title: "Active Users",
            value: "856",
            icon: "person.fill.checkmark",
            color: .green
        )

        StatCard(
            title: "Completion Rate",
            value: "73%",
            icon: "chart.line.uptrend.xyaxis",
            color: .purple
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
