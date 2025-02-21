import SwiftUI

struct CircleButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(.systemBackground))
                .frame(width: 44, height: 44)
                .background(.primary)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
        .tint(.primary)
    }
}

#Preview {
    CircleButton(icon: "arrow.up") {}
        .padding()
}
