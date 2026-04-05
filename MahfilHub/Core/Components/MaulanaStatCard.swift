import SwiftUI

// ══════════════════════════════════════════════════════════════════════════
// MARK: - MaulanaStatCard (Shared Component)
// ══════════════════════════════════════════════════════════════════════════
//
// Used by MaulanaView (with icon) and MaulanaDetailView (without icon).
// When `icon` is provided → shows a circular icon badge above the value.
// When `icon` is nil      → compact layout, value text uses `color`.

struct MaulanaStatCard: View {
    let value: String
    let label: String
    var icon: String? = nil
    let color: Color

    var body: some View {
        VStack(spacing: icon != nil ? 8 : 4) {
            if let icon {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.12))
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .font(.subheadline)
                        .foregroundStyle(color)
                }
            }

            Text(value)
                .font(.title2.bold())
                .foregroundStyle(icon != nil ? colorTextPrimary : color)

            Text(label)
                .font(.caption)
                .foregroundStyle(colorTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(icon != nil ? 16 : 0)
        .padding(.vertical, icon == nil ? 16 : 0)
        .background(Color.appCardSurface)
        .clipShape(.rect(cornerRadius: 14))
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}
