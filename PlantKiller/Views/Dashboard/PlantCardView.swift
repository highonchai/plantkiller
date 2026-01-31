import SwiftUI

// MARK: - Plant Card View
// Grid card showing plant with status

struct PlantCardView: View {
    let plant: Plant
    let onTap: () -> Void
    let onQuickWater: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: Theme.Spacing.sm) {
                // Plant image with status
                ZStack(alignment: .topTrailing) {
                    PlantImageView(plantTypeId: plant.plantTypeId, size: .medium)

                    // Status indicator
                    StatusIndicator(status: plant.status, size: .medium)
                        .offset(x: -Theme.Spacing.xs, y: Theme.Spacing.xs)

                    // Warning badge for bypassed plants
                    if plant.hasWarningBadge {
                        WarningBadge()
                            .offset(x: -Theme.Spacing.xs, y: Theme.Spacing.xxxl)
                    }
                }

                // Plant info
                VStack(spacing: Theme.Spacing.xxs) {
                    Text(plant.name)
                        .font(Theme.Typography.plantName)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .lineLimit(1)

                    Text(plant.nextWateringText)
                        .font(Theme.Typography.caption)
                        .foregroundColor(statusTextColor)
                        .lineLimit(1)
                }
            }
            .padding(Theme.Spacing.md)
            .frame(width: Theme.Sizes.plantCardWidth)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                    .fill(Theme.Colors.cardBackground)
                    .themeShadow(Theme.Shadows.card)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                    .stroke(statusBorderColor, lineWidth: needsAttention ? 2 : 0)
            )
        }
        .buttonStyle(CardButtonStyle())
        .contextMenu {
            Button(action: onQuickWater) {
                Label("Water Now", systemImage: "drop.fill")
            }
        }
    }

    private var needsAttention: Bool {
        plant.status != .healthy
    }

    private var statusTextColor: Color {
        switch plant.status {
        case .healthy: return Theme.Colors.textSecondary
        case .needsWater: return Theme.Colors.statusYellow
        case .critical: return Theme.Colors.statusRed
        }
    }

    private var statusBorderColor: Color {
        switch plant.status {
        case .healthy: return .clear
        case .needsWater: return Theme.Colors.statusYellow.opacity(0.5)
        case .critical: return Theme.Colors.statusRed.opacity(0.5)
        }
    }
}

// MARK: - Card Button Style

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(Theme.Animation.spring, value: configuration.isPressed)
    }
}

// MARK: - Plant Grid

struct PlantGrid: View {
    let plants: [Plant]
    let onSelectPlant: (Plant) -> Void
    let onWaterPlant: (Plant) -> Void

    private let columns = [
        GridItem(.adaptive(minimum: Theme.Sizes.plantCardWidth), spacing: Theme.Spacing.gridSpacing)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: Theme.Spacing.gridSpacing) {
            ForEach(plants) { plant in
                PlantCardView(
                    plant: plant,
                    onTap: { onSelectPlant(plant) },
                    onQuickWater: { onWaterPlant(plant) }
                )
            }
        }
        .padding(.horizontal, Theme.Spacing.screenPadding)
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(spacing: Theme.Spacing.xl) {
            PlantGrid(
                plants: Plant.samplePlants,
                onSelectPlant: { plant in
                    print("Selected: \(plant.name)")
                },
                onWaterPlant: { plant in
                    print("Watered: \(plant.name)")
                }
            )
        }
        .padding(.vertical, Theme.Spacing.lg)
    }
    .background(Theme.Colors.background)
}
