import SwiftUI

// MARK: - Watering Button
// Button with double-tap confirmation for watering plants

struct WateringButton: View {
    let plant: Plant
    let onWater: () -> Void

    @State private var confirmationStep = 0
    @State private var showingConfirmation = false

    var body: some View {
        Button(action: handleTap) {
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: buttonIcon)
                    .font(.system(size: 20, weight: .semibold))

                Text(buttonText)
                    .font(Theme.Typography.buttonText)
            }
            .foregroundColor(Theme.Colors.textOnPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: Theme.Sizes.buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.button)
                    .fill(buttonColor)
            )
            .themeShadow(Theme.Shadows.medium)
        }
        .animation(Theme.Animation.spring, value: confirmationStep)
    }

    private var buttonIcon: String {
        switch confirmationStep {
        case 0: return "drop.fill"
        case 1: return "checkmark"
        default: return "checkmark.circle.fill"
        }
    }

    private var buttonText: String {
        switch confirmationStep {
        case 0: return "Water Plant"
        case 1: return "Tap again to confirm"
        default: return "Watered!"
        }
    }

    private var buttonColor: Color {
        switch confirmationStep {
        case 0: return Theme.Colors.primaryDark
        case 1: return Theme.Colors.statusYellow
        default: return Theme.Colors.statusGreen
        }
    }

    private func handleTap() {
        if confirmationStep == 0 {
            confirmationStep = 1

            // Reset after 3 seconds if not confirmed
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if confirmationStep == 1 {
                    withAnimation {
                        confirmationStep = 0
                    }
                }
            }
        } else if confirmationStep == 1 {
            withAnimation {
                confirmationStep = 2
            }

            // Trigger the water action
            onWater()

            // Reset after showing success
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    confirmationStep = 0
                }
            }
        }
    }
}

// MARK: - Compact Watering Button

struct CompactWateringButton: View {
    let onWater: () -> Void

    @State private var tapped = false

    var body: some View {
        Button(action: {
            tapped = true
            onWater()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                tapped = false
            }
        }) {
            Image(systemName: tapped ? "checkmark.circle.fill" : "drop.fill")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(tapped ? Theme.Colors.statusGreen : Theme.Colors.primaryDark)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(Theme.Colors.cardBackground)
                        .themeShadow(Theme.Shadows.small)
                )
        }
        .animation(Theme.Animation.spring, value: tapped)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Theme.Spacing.xl) {
        WateringButton(plant: Plant.samplePlants[0]) {
            print("Watered!")
        }
        .padding(.horizontal, Theme.Spacing.screenPadding)

        CompactWateringButton {
            print("Quick water!")
        }
    }
    .padding()
    .background(Theme.Colors.background)
}
