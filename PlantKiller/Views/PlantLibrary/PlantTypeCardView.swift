import SwiftUI

// MARK: - Plant Type Card View
// Card for plant selection in the library

struct PlantTypeCardView: View {
    let plantType: PlantType
    let isUnlocked: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Theme.Spacing.md) {
                // Plant image
                ZStack {
                    PlantImageView(plantTypeId: plantType.id, size: .small)

                    if !isUnlocked {
                        Circle()
                            .fill(Theme.Colors.lockOverlay)
                            .frame(width: Theme.Sizes.plantImageSmall, height: Theme.Sizes.plantImageSmall)

                        Image(systemName: "lock.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }

                // Plant info
                VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                    Text(plantType.commonName)
                        .font(Theme.Typography.plantName)
                        .foregroundColor(isUnlocked ? Theme.Colors.textPrimary : Theme.Colors.textTertiary)

                    Text(plantType.scientificName)
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textTertiary)
                        .italic()

                    HStack(spacing: Theme.Spacing.sm) {
                        DifficultyStars(tier: plantType.tier)

                        Text(plantType.wateringFrequencyText)
                            .font(Theme.Typography.labelSmall)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                }

                Spacer()

                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.Colors.textTertiary)
            }
            .padding(Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                    .fill(Theme.Colors.cardBackground)
                    .themeShadow(Theme.Shadows.small)
            )
            .opacity(isUnlocked ? 1.0 : 0.8)
        }
        .buttonStyle(CardButtonStyle())
    }
}

// MARK: - Tier Section Header

struct TierSectionHeader: View {
    let tier: PlantTier
    let isUnlocked: Bool
    let plantCount: Int

    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            TierBadge(tier: tier, isLocked: !isUnlocked)

            Text("(\(plantCount) plants)")
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textTertiary)

            Spacer()

            if !isUnlocked {
                Text(tier.unlockRequirement)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textTertiary)
            }
        }
        .padding(.horizontal, Theme.Spacing.screenPadding)
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(spacing: Theme.Spacing.md) {
            TierSectionHeader(tier: .beginner, isUnlocked: true, plantCount: 4)

            ForEach(PlantType.plants(forTier: .beginner)) { plant in
                PlantTypeCardView(
                    plantType: plant,
                    isUnlocked: true,
                    onTap: {}
                )
            }
            .padding(.horizontal, Theme.Spacing.screenPadding)

            TierSectionHeader(tier: .intermediate, isUnlocked: false, plantCount: 4)

            ForEach(PlantType.plants(forTier: .intermediate)) { plant in
                PlantTypeCardView(
                    plantType: plant,
                    isUnlocked: false,
                    onTap: {}
                )
            }
            .padding(.horizontal, Theme.Spacing.screenPadding)
        }
        .padding(.vertical, Theme.Spacing.lg)
    }
    .background(Theme.Colors.background)
}
