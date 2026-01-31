import SwiftUI

// MARK: - Floating Action Button
// FAB for adding new plants

struct FloatingActionButton: View {
    let action: () -> Void
    var icon: String = "plus"

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()

            action()
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Theme.Colors.primaryDark,
                                Theme.Colors.primaryDark.opacity(0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: Theme.Sizes.fabSize, height: Theme.Sizes.fabSize)
                    .themeShadow(Theme.Shadows.fab)

                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Theme.Colors.textOnPrimary)
            }
        }
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .animation(Theme.Animation.spring, value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - FAB Container
// Positions the FAB correctly in the view hierarchy

struct FABContainer<Content: View>: View {
    let onTap: () -> Void
    let content: Content

    init(onTap: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.onTap = onTap
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            content

            FloatingActionButton(action: onTap)
                .padding(.trailing, Theme.Spacing.screenPadding)
                .padding(.bottom, Theme.Spacing.screenPadding + Theme.Sizes.tabBarHeight)
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Theme.Colors.background
            .ignoresSafeArea()

        VStack {
            Text("Content goes here")
                .font(Theme.Typography.bodyLarge)
                .foregroundColor(Theme.Colors.textSecondary)
        }

        VStack {
            Spacer()
            HStack {
                Spacer()
                FloatingActionButton(action: {
                    print("FAB tapped!")
                })
                .padding(Theme.Spacing.screenPadding)
            }
        }
    }
}
