import SwiftUI

// MARK: - Paywall View
// Premium upgrade screen (Superwall integration point)

struct PaywallView: View {
    let onPurchase: () -> Void
    let onRestore: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.xl) {
                    // Header
                    VStack(spacing: Theme.Spacing.md) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Theme.Colors.statusYellow)
                            .shadow(color: Theme.Colors.statusYellow.opacity(0.3), radius: 10)

                        Text("PlantKiller Premium")
                            .font(Theme.Typography.displayMedium)
                            .foregroundColor(Theme.Colors.textPrimary)

                        Text("Keep unlimited plants alive")
                            .font(Theme.Typography.bodyLarge)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                    .padding(.top, Theme.Spacing.xxl)

                    // Features
                    VStack(spacing: Theme.Spacing.md) {
                        FeatureRow(
                            icon: "leaf.fill",
                            title: "Unlimited Plants",
                            description: "Add as many plants as you want"
                        )

                        FeatureRow(
                            icon: "lock.open.fill",
                            title: "Access All Tiers",
                            description: "Add plants from any tier with bypass"
                        )

                        FeatureRow(
                            icon: "bell.badge.fill",
                            title: "Priority Notifications",
                            description: "Never miss a watering reminder"
                        )

                        FeatureRow(
                            icon: "heart.fill",
                            title: "Support Development",
                            description: "Help us make PlantKiller even better"
                        )
                    }
                    .padding(.horizontal, Theme.Spacing.screenPadding)

                    // Pricing
                    VStack(spacing: Theme.Spacing.md) {
                        PricingCard(
                            title: "Monthly",
                            price: "$2.99",
                            period: "/month",
                            isSelected: true
                        )
                    }
                    .padding(.horizontal, Theme.Spacing.screenPadding)

                    // CTA
                    VStack(spacing: Theme.Spacing.md) {
                        Button(action: onPurchase) {
                            Text("Start Premium")
                        }
                        .buttonStyle(PrimaryButtonStyle())

                        Button(action: onRestore) {
                            Text("Restore Purchases")
                                .font(Theme.Typography.labelMedium)
                                .foregroundColor(Theme.Colors.textSecondary)
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.screenPadding)

                    // Terms
                    VStack(spacing: Theme.Spacing.xs) {
                        Text("Cancel anytime. Subscription auto-renews monthly.")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textTertiary)

                        HStack(spacing: Theme.Spacing.md) {
                            Link("Terms", destination: URL(string: "https://plantkiller.app/terms")!)
                            Text("·")
                            Link("Privacy", destination: URL(string: "https://plantkiller.app/privacy")!)
                        }
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textTertiary)
                    }
                    .padding(.bottom, Theme.Spacing.xl)
                }
            }
            .background(Theme.Colors.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Theme.Colors.textTertiary)
                    }
                }
            }
        }
    }
}

// MARK: - Feature Row

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(Theme.Colors.primaryDark)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Theme.Colors.primaryLight.opacity(0.2))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Theme.Typography.labelLarge)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text(description)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            Spacer()

            Image(systemName: "checkmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Theme.Colors.statusGreen)
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                .fill(Theme.Colors.cardBackground)
        )
    }
}

// MARK: - Pricing Card

struct PricingCard: View {
    let title: String
    let price: String
    let period: String
    var isSelected: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Theme.Typography.labelLarge)
                    .foregroundColor(Theme.Colors.textPrimary)

                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(price)
                        .font(Theme.Typography.displaySmall)
                        .foregroundColor(Theme.Colors.primaryDark)

                    Text(period)
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Theme.Colors.primaryDark)
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                .fill(Theme.Colors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                        .stroke(isSelected ? Theme.Colors.primaryDark : Theme.Colors.border, lineWidth: isSelected ? 2 : 1)
                )
        )
    }
}

// MARK: - Preview

#Preview {
    PaywallView(
        onPurchase: {},
        onRestore: {},
        onDismiss: {}
    )
}
