import SwiftUI

// MARK: - Notification Banner
// Warning banner shown when notifications are disabled

struct NotificationBanner: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: "bell.slash.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Theme.Colors.warningBannerBorder)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Notifications are off")
                        .font(Theme.Typography.labelLarge)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Text("Your plants will die! Tap to enable.")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.Colors.textTertiary)
            }
            .padding(Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                    .fill(Theme.Colors.warningBanner)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                            .stroke(Theme.Colors.warningBannerBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Info Banner

struct InfoBanner: View {
    let icon: String
    let title: String
    let subtitle: String?
    var backgroundColor: Color = Theme.Colors.primaryLight.opacity(0.2)
    var borderColor: Color = Theme.Colors.primaryDark
    var iconColor: Color = Theme.Colors.primaryDark

    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(iconColor)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Theme.Typography.labelLarge)
                    .foregroundColor(Theme.Colors.textPrimary)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }

            Spacer()
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                        .stroke(borderColor.opacity(0.5), lineWidth: 1)
                )
        )
    }
}

// MARK: - Plant Limit Banner

struct PlantLimitBanner: View {
    let currentCount: Int
    let maxCount: Int
    let onUpgrade: () -> Void

    var body: some View {
        Button(action: onUpgrade) {
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Theme.Colors.statusYellow)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Free plan: \(currentCount)/\(maxCount) plants")
                        .font(Theme.Typography.labelLarge)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Text("Upgrade to Premium for unlimited plants")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                Spacer()

                Text("Upgrade")
                    .font(Theme.Typography.labelMedium)
                    .foregroundColor(Theme.Colors.primaryDark)
                    .padding(.horizontal, Theme.Spacing.sm)
                    .padding(.vertical, Theme.Spacing.xs)
                    .background(
                        Capsule()
                            .fill(Theme.Colors.primaryLight.opacity(0.3))
                    )
            }
            .padding(Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                    .fill(Theme.Colors.backgroundSecondary)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Resurrection Banner

struct ResurrectionBanner: View {
    let daysRemaining: Int

    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            Image(systemName: "arrow.counterclockwise.circle.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.Colors.statusGreen)

            Text("Can be resurrected")
                .font(Theme.Typography.labelMedium)
                .foregroundColor(Theme.Colors.statusGreen)

            Spacer()

            Text("\(daysRemaining) day\(daysRemaining == 1 ? "" : "s") left")
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .padding(Theme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.sm)
                .fill(Theme.Colors.statusGreen.opacity(0.1))
        )
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Theme.Spacing.md) {
        NotificationBanner(onTap: {})

        InfoBanner(
            icon: "lightbulb.fill",
            title: "Pro tip",
            subtitle: "Water in the morning for best results"
        )

        PlantLimitBanner(currentCount: 2, maxCount: 2, onUpgrade: {})

        ResurrectionBanner(daysRemaining: 5)
    }
    .padding()
    .background(Theme.Colors.background)
}
