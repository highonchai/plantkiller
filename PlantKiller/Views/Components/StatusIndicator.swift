import SwiftUI

// MARK: - Status Indicator
// Shows plant health status with color-coded indicator

struct StatusIndicator: View {
    let status: PlantStatus
    var size: Size = .medium
    var showLabel: Bool = false

    enum Size {
        case small, medium, large

        var dimension: CGFloat {
            switch self {
            case .small: return Theme.Sizes.statusIndicatorSize
            case .medium: return Theme.Sizes.statusIndicatorLarge
            case .large: return 20
            }
        }

        var fontSize: Font {
            switch self {
            case .small: return Theme.Typography.labelSmall
            case .medium: return Theme.Typography.labelMedium
            case .large: return Theme.Typography.labelLarge
            }
        }
    }

    var body: some View {
        HStack(spacing: Theme.Spacing.xs) {
            Circle()
                .fill(statusColor)
                .frame(width: size.dimension, height: size.dimension)
                .overlay(
                    Circle()
                        .stroke(statusColor.opacity(0.3), lineWidth: 2)
                )
                .shadow(color: statusColor.opacity(0.4), radius: 4, x: 0, y: 2)

            if showLabel {
                Text(status.displayText)
                    .font(size.fontSize)
                    .foregroundColor(statusColor)
            }
        }
    }

    private var statusColor: Color {
        switch status {
        case .healthy: return Theme.Colors.statusGreen
        case .needsWater: return Theme.Colors.statusYellow
        case .critical: return Theme.Colors.statusRed
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Theme.Spacing.lg) {
        HStack(spacing: Theme.Spacing.xl) {
            StatusIndicator(status: .healthy, size: .small)
            StatusIndicator(status: .needsWater, size: .small)
            StatusIndicator(status: .critical, size: .small)
        }

        HStack(spacing: Theme.Spacing.xl) {
            StatusIndicator(status: .healthy, size: .medium)
            StatusIndicator(status: .needsWater, size: .medium)
            StatusIndicator(status: .critical, size: .medium)
        }

        HStack(spacing: Theme.Spacing.xl) {
            StatusIndicator(status: .healthy, size: .large, showLabel: true)
            StatusIndicator(status: .needsWater, size: .large, showLabel: true)
            StatusIndicator(status: .critical, size: .large, showLabel: true)
        }
    }
    .padding()
    .background(Theme.Colors.background)
}
