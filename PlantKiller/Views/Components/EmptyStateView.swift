import SwiftUI

// MARK: - Empty State View
// Shown when there are no plants or graveyard entries

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Icon
            ZStack {
                Circle()
                    .fill(Theme.Colors.backgroundSecondary)
                    .frame(width: 100, height: 100)

                Image(systemName: icon)
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(Theme.Colors.textTertiary)
            }

            // Text
            VStack(spacing: Theme.Spacing.xs) {
                Text(title)
                    .font(Theme.Typography.headlineMedium)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .multilineTextAlignment(.center)

                Text(subtitle)
                    .font(Theme.Typography.bodyMedium)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, Theme.Spacing.xl)

            // Action button (optional)
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, Theme.Spacing.huge)
                .padding(.top, Theme.Spacing.sm)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.Colors.background)
    }
}

// MARK: - Dashboard Empty State

struct DashboardEmptyState: View {
    let onAddPlant: () -> Void

    var body: some View {
        EmptyStateView(
            icon: "leaf.fill",
            title: "No Plants Yet",
            subtitle: "Add your first plant and we'll help you keep it alive. No judgment.",
            actionTitle: "Add Your First Plant",
            action: onAddPlant
        )
    }
}

// MARK: - Graveyard Empty State

struct GraveyardEmptyState: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Happy tombstone illustration
            ZStack {
                Circle()
                    .fill(Theme.Colors.graveyardBackground)
                    .frame(width: 120, height: 120)

                VStack(spacing: 4) {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(Theme.Colors.statusGreen)

                    Text("0")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.Colors.statusGreen)
                }
            }

            VStack(spacing: Theme.Spacing.xs) {
                Text("No Dead Plants!")
                    .font(Theme.Typography.headlineMedium)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text("Your graveyard is empty.\nLet's keep it that way!")
                    .font(Theme.Typography.bodyMedium)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.Colors.graveyardBackground)
    }
}

// MARK: - Preview

#Preview {
    VStack {
        DashboardEmptyState(onAddPlant: {})

        Divider()

        GraveyardEmptyState()
    }
}
