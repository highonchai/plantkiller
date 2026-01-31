import SwiftUI

// MARK: - Plant Image View
// Displays 3D isometric plant illustrations

struct PlantImageView: View {
    let plantTypeId: String
    var size: Size = .medium
    var showShadow: Bool = true

    enum Size {
        case small, medium, large, extraLarge

        var dimension: CGFloat {
            switch self {
            case .small: return Theme.Sizes.plantImageSmall
            case .medium: return Theme.Sizes.plantImageMedium
            case .large: return Theme.Sizes.plantImageLarge
            case .extraLarge: return Theme.Sizes.plantImageXL
            }
        }
    }

    var body: some View {
        ZStack {
            // Background gradient for depth
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Theme.Colors.primaryLight.opacity(0.3),
                            Theme.Colors.primaryLight.opacity(0.1),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size.dimension / 2
                    )
                )
                .frame(width: size.dimension, height: size.dimension)

            // Plant illustration
            plantImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.dimension * 0.85, height: size.dimension * 0.85)
        }
        .frame(width: size.dimension, height: size.dimension)
        .themeShadow(showShadow ? Theme.Shadows.small : Theme.Shadows.none)
    }

    @ViewBuilder
    private var plantImage: Image {
        // In production, this would load actual plant assets
        // For now, using SF Symbols as placeholders
        Image(systemName: plantIcon)
            .symbolRenderingMode(.hierarchical)
    }

    private var plantIcon: String {
        switch plantTypeId {
        case "pothos": return "leaf.fill"
        case "snake_plant": return "leaf.arrow.triangle.circlepath"
        case "spider_plant": return "aqi.medium"
        case "zz_plant": return "leaf.circle.fill"
        case "monstera": return "laurel.leading"
        case "peace_lily": return "flame.fill"
        case "rubber_plant": return "leaf.fill"
        case "philodendron": return "wind"
        case "fiddle_leaf_fig": return "tree.fill"
        case "calathea": return "sparkles"
        default: return "leaf.fill"
        }
    }
}

// MARK: - Tombstone Image View

struct TombstoneImageView: View {
    let plantTypeId: String
    var size: CGFloat = Theme.Sizes.tombstoneWidth

    var body: some View {
        ZStack {
            // Tombstone shape
            TombstoneShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Theme.Colors.gravestoneLight,
                            Theme.Colors.gravestone,
                            Theme.Colors.gravestoneDark
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.7, height: size * 0.9)
                .themeShadow(Theme.Shadows.tombstone)

            // RIP text
            VStack(spacing: Theme.Spacing.xs) {
                Text("R.I.P.")
                    .font(Theme.Typography.tombstoneText)
                    .foregroundColor(Theme.Colors.textOnDark.opacity(0.8))

                // Small plant icon
                Image(systemName: "leaf.fill")
                    .font(.system(size: size * 0.15))
                    .foregroundColor(Theme.Colors.statusGreen.opacity(0.6))
            }
            .offset(y: -size * 0.05)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Tombstone Shape

struct TombstoneShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height
        let cornerRadius = width * 0.3

        // Start from bottom left
        path.move(to: CGPoint(x: 0, y: height))

        // Left side
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))

        // Top arc
        path.addArc(
            center: CGPoint(x: width / 2, y: cornerRadius),
            radius: width / 2,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )

        // Right side
        path.addLine(to: CGPoint(x: width, y: height))

        // Bottom
        path.addLine(to: CGPoint(x: 0, y: height))

        return path
    }
}

// MARK: - Animated Plant Image

struct AnimatedPlantImageView: View {
    let plantTypeId: String
    var size: PlantImageView.Size = .medium

    @State private var isAnimating = false

    var body: some View {
        PlantImageView(plantTypeId: plantTypeId, size: size)
            .scaleEffect(isAnimating ? 1.05 : 1.0)
            .animation(
                Animation.easeInOut(duration: 2)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(spacing: Theme.Spacing.xl) {
            Text("Plant Images")
                .font(Theme.Typography.headlineMedium)

            HStack(spacing: Theme.Spacing.md) {
                PlantImageView(plantTypeId: "pothos", size: .small)
                PlantImageView(plantTypeId: "snake_plant", size: .small)
                PlantImageView(plantTypeId: "monstera", size: .small)
            }

            PlantImageView(plantTypeId: "pothos", size: .medium)
            PlantImageView(plantTypeId: "monstera", size: .large)

            Divider()

            Text("Tombstones")
                .font(Theme.Typography.headlineMedium)

            HStack(spacing: Theme.Spacing.md) {
                TombstoneImageView(plantTypeId: "pothos", size: 100)
                TombstoneImageView(plantTypeId: "snake_plant", size: 100)
            }

            Divider()

            Text("Animated")
                .font(Theme.Typography.headlineMedium)

            AnimatedPlantImageView(plantTypeId: "pothos", size: .large)
        }
        .padding()
    }
    .background(Theme.Colors.background)
}
