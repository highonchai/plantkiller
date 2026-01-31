import SwiftUI

// MARK: - Global Theme
// All colors, fonts, spacing, corner radius, and shadows are defined here
// NO hardcoded styles inside components - always reference Theme

struct Theme {

    // MARK: - Colors
    struct Colors {
        // Primary brand colors
        static let primary = Color("Primary", bundle: nil)
        static let primaryDark = Color(hex: "#2D5A3D")
        static let primaryLight = Color(hex: "#8FBC8F")

        // Secondary colors
        static let secondary = Color(hex: "#8B4513")  // Terracotta
        static let secondaryLight = Color(hex: "#CD853F")

        // Status colors
        static let statusGreen = Color(hex: "#4CAF50")
        static let statusYellow = Color(hex: "#FFC107")
        static let statusRed = Color(hex: "#F44336")

        // Graveyard colors
        static let gravestone = Color(hex: "#4A5568")
        static let gravestoneLight = Color(hex: "#718096")
        static let gravestoneDark = Color(hex: "#2D3748")

        // Backgrounds
        static let background = Color(hex: "#F7F5F0")
        static let backgroundSecondary = Color(hex: "#EDEAE3")
        static let cardBackground = Color.white
        static let graveyardBackground = Color(hex: "#E8E6E1")

        // Text colors
        static let textPrimary = Color(hex: "#1A1A1A")
        static let textSecondary = Color(hex: "#6B7280")
        static let textTertiary = Color(hex: "#9CA3AF")
        static let textOnPrimary = Color.white
        static let textOnDark = Color.white

        // UI Elements
        static let divider = Color(hex: "#E5E7EB")
        static let border = Color(hex: "#D1D5DB")
        static let overlay = Color.black.opacity(0.5)
        static let lockOverlay = Color.black.opacity(0.4)

        // Tier colors
        static let tierBeginner = Color(hex: "#4CAF50")
        static let tierIntermediate = Color(hex: "#FF9800")
        static let tierAdvanced = Color(hex: "#F44336")
        static let tierExpert = Color(hex: "#9C27B0")

        // Notification banner
        static let warningBanner = Color(hex: "#FEF3C7")
        static let warningBannerBorder = Color(hex: "#F59E0B")
    }

    // MARK: - Typography
    struct Typography {
        // Font names
        private static let primaryFontName = "System"

        // Display
        static let displayLarge = Font.system(size: 34, weight: .bold, design: .rounded)
        static let displayMedium = Font.system(size: 28, weight: .bold, design: .rounded)
        static let displaySmall = Font.system(size: 24, weight: .bold, design: .rounded)

        // Headlines
        static let headlineLarge = Font.system(size: 22, weight: .semibold, design: .rounded)
        static let headlineMedium = Font.system(size: 20, weight: .semibold, design: .rounded)
        static let headlineSmall = Font.system(size: 18, weight: .semibold, design: .rounded)

        // Body
        static let bodyLarge = Font.system(size: 17, weight: .regular, design: .default)
        static let bodyMedium = Font.system(size: 15, weight: .regular, design: .default)
        static let bodySmall = Font.system(size: 13, weight: .regular, design: .default)

        // Labels
        static let labelLarge = Font.system(size: 15, weight: .medium, design: .default)
        static let labelMedium = Font.system(size: 13, weight: .medium, design: .default)
        static let labelSmall = Font.system(size: 11, weight: .medium, design: .default)

        // Caption
        static let caption = Font.system(size: 12, weight: .regular, design: .default)
        static let captionBold = Font.system(size: 12, weight: .semibold, design: .default)

        // Special
        static let plantName = Font.system(size: 16, weight: .semibold, design: .rounded)
        static let tombstoneText = Font.system(size: 14, weight: .bold, design: .serif)
        static let buttonText = Font.system(size: 16, weight: .semibold, design: .rounded)
        static let tabLabel = Font.system(size: 10, weight: .medium, design: .default)
    }

    // MARK: - Spacing
    struct Spacing {
        static let xxxs: CGFloat = 2
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 40
        static let huge: CGFloat = 48
        static let massive: CGFloat = 64

        // Specific use cases
        static let cardPadding: CGFloat = 16
        static let screenPadding: CGFloat = 20
        static let gridSpacing: CGFloat = 16
        static let listItemSpacing: CGFloat = 12
        static let sectionSpacing: CGFloat = 24
        static let componentSpacing: CGFloat = 8
    }

    // MARK: - Corner Radius
    struct CornerRadius {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let full: CGFloat = 999

        // Specific use cases
        static let card: CGFloat = 16
        static let button: CGFloat = 12
        static let buttonSmall: CGFloat = 8
        static let modal: CGFloat = 24
        static let tombstone: CGFloat = 8
        static let plantImage: CGFloat = 12
        static let fab: CGFloat = 28
    }

    // MARK: - Shadows
    struct Shadows {
        static let none = Shadow(color: .clear, radius: 0, x: 0, y: 0)

        static let small = Shadow(
            color: Color.black.opacity(0.08),
            radius: 4,
            x: 0,
            y: 2
        )

        static let medium = Shadow(
            color: Color.black.opacity(0.12),
            radius: 8,
            x: 0,
            y: 4
        )

        static let large = Shadow(
            color: Color.black.opacity(0.16),
            radius: 16,
            x: 0,
            y: 8
        )

        static let card = Shadow(
            color: Color.black.opacity(0.1),
            radius: 8,
            x: 0,
            y: 4
        )

        static let fab = Shadow(
            color: Colors.primaryDark.opacity(0.3),
            radius: 12,
            x: 0,
            y: 6
        )

        static let tombstone = Shadow(
            color: Color.black.opacity(0.2),
            radius: 6,
            x: 2,
            y: 4
        )

        static let modal = Shadow(
            color: Color.black.opacity(0.2),
            radius: 20,
            x: 0,
            y: 10
        )
    }

    // MARK: - Sizes
    struct Sizes {
        // Icons
        static let iconXS: CGFloat = 16
        static let iconSM: CGFloat = 20
        static let iconMD: CGFloat = 24
        static let iconLG: CGFloat = 32
        static let iconXL: CGFloat = 40

        // Plant images
        static let plantImageSmall: CGFloat = 60
        static let plantImageMedium: CGFloat = 100
        static let plantImageLarge: CGFloat = 150
        static let plantImageXL: CGFloat = 200

        // Cards
        static let plantCardWidth: CGFloat = 160
        static let plantCardHeight: CGFloat = 200
        static let tombstoneWidth: CGFloat = 140
        static let tombstoneHeight: CGFloat = 180

        // Buttons
        static let buttonHeight: CGFloat = 50
        static let buttonHeightSmall: CGFloat = 40
        static let fabSize: CGFloat = 56

        // Status indicator
        static let statusIndicatorSize: CGFloat = 12
        static let statusIndicatorLarge: CGFloat = 16

        // Tab bar
        static let tabBarHeight: CGFloat = 83

        // Navigation
        static let navBarHeight: CGFloat = 44
    }

    // MARK: - Animation
    struct Animation {
        static let fast: Double = 0.15
        static let normal: Double = 0.25
        static let slow: Double = 0.4
        static let spring = SwiftUI.Animation.spring(response: 0.35, dampingFraction: 0.7)
        static let springBouncy = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.6)
        static let easeOut = SwiftUI.Animation.easeOut(duration: 0.25)
        static let easeInOut = SwiftUI.Animation.easeInOut(duration: 0.3)
    }
}

// MARK: - Shadow Helper
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Extension for Shadow
extension View {
    func themeShadow(_ shadow: Shadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Theme Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    var isEnabled: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.Typography.buttonText)
            .foregroundColor(Theme.Colors.textOnPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: Theme.Sizes.buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.button)
                    .fill(isEnabled ? Theme.Colors.primaryDark : Theme.Colors.textTertiary)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(Theme.Animation.spring, value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.Typography.buttonText)
            .foregroundColor(Theme.Colors.primaryDark)
            .frame(maxWidth: .infinity)
            .frame(height: Theme.Sizes.buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.button)
                    .stroke(Theme.Colors.primaryDark, lineWidth: 2)
            )
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(Theme.Animation.spring, value: configuration.isPressed)
    }
}

struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.Typography.buttonText)
            .foregroundColor(Theme.Colors.statusRed)
            .frame(maxWidth: .infinity)
            .frame(height: Theme.Sizes.buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.button)
                    .stroke(Theme.Colors.statusRed, lineWidth: 2)
            )
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(Theme.Animation.spring, value: configuration.isPressed)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Theme.Spacing.md) {
        Text("Theme Preview")
            .font(Theme.Typography.displayMedium)
            .foregroundColor(Theme.Colors.textPrimary)

        HStack(spacing: Theme.Spacing.sm) {
            Circle()
                .fill(Theme.Colors.statusGreen)
                .frame(width: Theme.Sizes.statusIndicatorLarge, height: Theme.Sizes.statusIndicatorLarge)
            Circle()
                .fill(Theme.Colors.statusYellow)
                .frame(width: Theme.Sizes.statusIndicatorLarge, height: Theme.Sizes.statusIndicatorLarge)
            Circle()
                .fill(Theme.Colors.statusRed)
                .frame(width: Theme.Sizes.statusIndicatorLarge, height: Theme.Sizes.statusIndicatorLarge)
        }

        Button("Primary Button") {}
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, Theme.Spacing.screenPadding)

        Button("Secondary Button") {}
            .buttonStyle(SecondaryButtonStyle())
            .padding(.horizontal, Theme.Spacing.screenPadding)
    }
    .padding()
    .background(Theme.Colors.background)
}
