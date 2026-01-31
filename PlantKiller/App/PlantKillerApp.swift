import SwiftUI

// MARK: - PlantKiller App
// Main app entry point

@main
struct PlantKillerApp: App {
    @State private var appViewModel = AppViewModel.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appViewModel)
        }
    }
}

// MARK: - Content View
// Root view that handles onboarding vs main app

struct ContentView: View {
    @Environment(AppViewModel.self) private var appViewModel

    var body: some View {
        Group {
            if appViewModel.shouldShowOnboarding {
                OnboardingView(
                    viewModel: appViewModel.onboardingViewModel,
                    onComplete: { plant in
                        appViewModel.completeOnboarding(with: plant)
                    },
                    onSkip: {
                        appViewModel.skipOnboarding()
                    }
                )
            } else {
                MainTabView(appViewModel: appViewModel)
            }
        }
        .animation(Theme.Animation.easeInOut, value: appViewModel.shouldShowOnboarding)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .environment(AppViewModel.shared)
}
