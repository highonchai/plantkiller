import SwiftUI

// MARK: - Lock Overlay
// Shows lock icon for locked plant tiers

struct LockOverlay: View {
    let tier: PlantTier
    var showUnlockInfo: Bool = true

    var body: some View {
        ZStack {
            // Semi-transparent overlay
            Rectangle()
                .fill(Theme.Colors.lockOverlay)

            VStack(spacing: Theme.Spacing.sm) {
                // Lock icon
                Image(systemName: "lock.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)

                if showUnlockInfo {
                    Text(tier.unlockRequirement)
                        .font(Theme.Typography.caption)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.Spacing.sm)
                }
            }
        }
    }
}

// MARK: - Tier Badge

struct TierBadge: View {
    let tier: PlantTier
    var isLocked: Bool = false
    var size: Size = .medium

    enum Size {
        case small, medium, large

        var padding: CGFloat {
            switch self {
            case .small: return 4
            case .medium: return 6
            case .large: return 8
            }
        }

        var font: Font {
            switch self {
            case .small: return Theme.Typography.labelSmall
            case .medium: return Theme.Typography.labelMedium
            case .large: return Theme.Typography.labelLarge
            }
        }

        var iconSize: CGFloat {
            switch self {
            case .small: return 10
            case .medium: return 12
            case .large: return 14
            }
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            if isLocked {
                Image(systemName: "lock.fill")
                    .font(.system(size: size.iconSize, weight: .semibold))
            } else {
                Image(systemName: tier.iconName)
                    .font(.system(size: size.iconSize, weight: .semibold))
            }

            Text(tier.displayName)
                .font(size.font)
        }
        .foregroundColor(.white)
        .padding(.horizontal, size.padding + 4)
        .padding(.vertical, size.padding)
        .background(
            Capsule()
                .fill(isLocked ? Theme.Colors.textSecondary : tier.color)
        )
    }
}

// MARK: - Warning Badge

struct WarningBadge: View {
    var body: some View {
        Image(systemName: "exclamationmark.triangle.fill")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(Theme.Colors.statusYellow)
            .padding(4)
            .background(
                Circle()
                    .fill(Theme.Colors.cardBackground)
                    .themeShadow(Theme.Shadows.small)
            )
    }
}

// MARK: - Difficulty Stars

struct DifficultyStars: View {
    let tier: PlantTier

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...4, id: \.self) { star in
                Image(systemName: star <= tier.rawValue ? "star.fill" : "star")
                    .font(.system(size: 12))
                    .foregroundColor(star <= tier.rawValue ? tier.color : Theme.Colors.textTertiary)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Theme.Spacing.xl) {
        // Lock overlays
        HStack(spacing: Theme.Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                    .fill(Theme.Colors.primaryLight)
                    .frame(width: 100, height: 120)

                LockOverlay(tier: .intermediate)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.card))
            }

            ZStack {
                RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                    .fill(Theme.Colors.primaryLight)
                    .frame(width: 100, height: 120)

                LockOverlay(tier: .advanced, showUnlockInfo: false)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.card))
            }
        }

        // Tier badges
        HStack(spacing: Theme.Spacing.sm) {
            TierBadge(tier: .beginner)
            TierBadge(tier: .intermediate)
            TierBadge(tier: .advanced, isLocked: true)
        }

        // Sizes
        HStack(spacing: Theme.Spacing.sm) {
            TierBadge(tier: .beginner, size: .small)
            TierBadge(tier: .beginner, size: .medium)
            TierBadge(tier: .beginner, size: .large)
        }

        // Difficulty stars
        VStack(spacing: Theme.Spacing.sm) {
            DifficultyStars(tier: .beginner)
            DifficultyStars(tier: .intermediate)
            DifficultyStars(tier: .advanced)
        }

        // Warning badge
        WarningBadge()
    }
    .padding()
    .background(Theme.Colors.background)
}
