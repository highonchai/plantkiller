import SwiftUI

// MARK: - Onboarding View
// Main onboarding flow container

struct OnboardingView: View {
    @Bindable var viewModel: OnboardingViewModel
    let onComplete: (Plant) -> Void
    let onSkip: () -> Void

    var body: some View {
        ZStack {
            Theme.Colors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar
                ProgressBar(progress: viewModel.progress)
                    .padding(.horizontal, Theme.Spacing.screenPadding)
                    .padding(.top, Theme.Spacing.md)

                // Content
                TabView(selection: Binding(
                    get: { viewModel.currentStep },
                    set: { _ in }
                )) {
                    WelcomeStep(viewModel: viewModel)
                        .tag(OnboardingViewModel.Step.welcome)

                    KillerQuestionStep(viewModel: viewModel)
                        .tag(OnboardingViewModel.Step.killerQuestion)

                    PlantSelectionStep(viewModel: viewModel)
                        .tag(OnboardingViewModel.Step.plantSelection)

                    ScheduleSetupStep(viewModel: viewModel)
                        .tag(OnboardingViewModel.Step.scheduleSetup)

                    NamePlantStep(viewModel: viewModel)
                        .tag(OnboardingViewModel.Step.namePlant)

                    CompleteStep(viewModel: viewModel, onComplete: {
                        if let plant = viewModel.createFirstPlant() {
                            onComplete(plant)
                        }
                    })
                    .tag(OnboardingViewModel.Step.complete)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(Theme.Animation.easeInOut, value: viewModel.currentStep)
            }
        }
        .onAppear {
            viewModel.start()
        }
    }
}

// MARK: - Progress Bar

struct ProgressBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: Theme.CornerRadius.full)
                    .fill(Theme.Colors.backgroundSecondary)
                    .frame(height: 4)

                RoundedRectangle(cornerRadius: Theme.CornerRadius.full)
                    .fill(Theme.Colors.primaryDark)
                    .frame(width: geometry.size.width * progress, height: 4)
                    .animation(Theme.Animation.easeInOut, value: progress)
            }
        }
        .frame(height: 4)
    }
}

// MARK: - Welcome Step

struct WelcomeStep: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            Spacer()

            // Logo/Icon
            ZStack {
                Circle()
                    .fill(Theme.Colors.primaryLight.opacity(0.2))
                    .frame(width: 150, height: 150)

                Image(systemName: "leaf.fill")
                    .font(.system(size: 70, weight: .medium))
                    .foregroundColor(Theme.Colors.primaryDark)
            }

            // Text
            VStack(spacing: Theme.Spacing.md) {
                Text("PlantKiller")
                    .font(Theme.Typography.displayLarge)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text(viewModel.welcomeText)
                    .font(Theme.Typography.headlineSmall)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)

                Text(viewModel.welcomeSubtext)
                    .font(Theme.Typography.bodyMedium)
                    .foregroundColor(Theme.Colors.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.xl)
            }

            Spacer()

            // Button
            Button(action: { viewModel.nextStep() }) {
                Text("Get Started")
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, Theme.Spacing.screenPadding)
            .padding(.bottom, Theme.Spacing.xxl)
        }
    }
}

// MARK: - Killer Question Step

struct KillerQuestionStep: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            Spacer()

            // Question
            VStack(spacing: Theme.Spacing.lg) {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Theme.Colors.statusYellow)

                Text(viewModel.killerQuestionText)
                    .font(Theme.Typography.displaySmall)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .multilineTextAlignment(.center)

                Text(viewModel.killerQuestionSubtext)
                    .font(Theme.Typography.bodyMedium)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, Theme.Spacing.xl)

            Spacer()

            // Buttons
            VStack(spacing: Theme.Spacing.md) {
                Button(action: {
                    viewModel.answerKillerQuestion(admitted: true)
                    viewModel.nextStep()
                }) {
                    Text(viewModel.yesButtonText)
                }
                .buttonStyle(PrimaryButtonStyle())

                Button(action: {
                    viewModel.answerKillerQuestion(admitted: false)
                    viewModel.nextStep()
                }) {
                    Text(viewModel.noButtonText)
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding(.horizontal, Theme.Spacing.screenPadding)
            .padding(.bottom, Theme.Spacing.xxl)
        }
    }
}

// MARK: - Plant Selection Step

struct PlantSelectionStep: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Header
            VStack(spacing: Theme.Spacing.xs) {
                Text("Choose Your First Plant")
                    .font(Theme.Typography.displaySmall)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text("Start with something easy")
                    .font(Theme.Typography.bodyMedium)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            .padding(.top, Theme.Spacing.xl)

            // Plant grid
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 150))],
                    spacing: Theme.Spacing.md
                ) {
                    ForEach(viewModel.availablePlants) { plantType in
                        OnboardingPlantCard(
                            plantType: plantType,
                            isSelected: viewModel.selectedPlantType?.id == plantType.id,
                            onTap: { viewModel.selectPlant(plantType) }
                        )
                    }
                }
                .padding(.horizontal, Theme.Spacing.screenPadding)
            }

            // Next button
            Button(action: { viewModel.nextStep() }) {
                Text("Continue")
            }
            .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.selectedPlantType != nil))
            .disabled(viewModel.selectedPlantType == nil)
            .padding(.horizontal, Theme.Spacing.screenPadding)
            .padding(.bottom, Theme.Spacing.xl)
        }
    }
}

// MARK: - Onboarding Plant Card

struct OnboardingPlantCard: View {
    let plantType: PlantType
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: Theme.Spacing.sm) {
                PlantImageView(plantTypeId: plantType.id, size: .medium)

                VStack(spacing: Theme.Spacing.xxs) {
                    Text(plantType.commonName)
                        .font(Theme.Typography.plantName)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Text(plantType.wateringFrequencyText)
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }
            .padding(Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                    .fill(Theme.Colors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                            .stroke(isSelected ? Theme.Colors.primaryDark : Color.clear, lineWidth: 3)
                    )
                    .themeShadow(Theme.Shadows.card)
            )
        }
        .buttonStyle(CardButtonStyle())
    }
}

// MARK: - Schedule Setup Step

struct ScheduleSetupStep: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            Spacer()

            // Header
            VStack(spacing: Theme.Spacing.md) {
                if let plantType = viewModel.selectedPlantType {
                    PlantImageView(plantTypeId: plantType.id, size: .large)
                }

                Text("Set Watering Schedule")
                    .font(Theme.Typography.displaySmall)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text("How often should we remind you?")
                    .font(Theme.Typography.bodyMedium)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            // Picker
            Picker("Watering frequency", selection: $viewModel.wateringDays) {
                ForEach([1, 2, 3, 4, 5, 6, 7, 10, 14, 21, 30], id: \.self) { days in
                    Text(wateringLabel(days)).tag(days)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 150)

            // Recommendation
            if let plantType = viewModel.selectedPlantType {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(Theme.Colors.statusYellow)

                    Text("Recommended: \(plantType.wateringFrequencyText)")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }

            Spacer()

            // Button
            Button(action: { viewModel.nextStep() }) {
                Text("Continue")
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, Theme.Spacing.screenPadding)
            .padding(.bottom, Theme.Spacing.xxl)
        }
    }

    private func wateringLabel(_ days: Int) -> String {
        switch days {
        case 1: return "Daily"
        case 7: return "Weekly"
        case 14: return "Every 2 weeks"
        default: return "Every \(days) days"
        }
    }
}

// MARK: - Name Plant Step

struct NamePlantStep: View {
    @Bindable var viewModel: OnboardingViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            Spacer()

            // Header
            VStack(spacing: Theme.Spacing.md) {
                if let plantType = viewModel.selectedPlantType {
                    PlantImageView(plantTypeId: plantType.id, size: .large)
                }

                Text("Name Your Plant")
                    .font(Theme.Typography.displaySmall)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text("Give it a personality (optional)")
                    .font(Theme.Typography.bodyMedium)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            // Text field
            TextField("e.g., Gerald, Planty McPlantface", text: $viewModel.plantName)
                .font(Theme.Typography.headlineMedium)
                .multilineTextAlignment(.center)
                .textFieldStyle(.plain)
                .padding(Theme.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                        .fill(Theme.Colors.backgroundSecondary)
                )
                .padding(.horizontal, Theme.Spacing.xl)
                .focused($isFocused)

            // Default name hint
            if viewModel.plantName.isEmpty {
                Text("Or we'll call it \(viewModel.selectedPlantType?.commonName ?? "Plant")")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textTertiary)
            }

            Spacer()

            // Button
            Button(action: { viewModel.nextStep() }) {
                Text(viewModel.plantName.isEmpty ? "Skip" : "Continue")
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, Theme.Spacing.screenPadding)
            .padding(.bottom, Theme.Spacing.xxl)
        }
        .onTapGesture {
            isFocused = false
        }
    }
}

// MARK: - Complete Step

struct CompleteStep: View {
    @Bindable var viewModel: OnboardingViewModel
    let onComplete: () -> Void

    @State private var showConfetti = false

    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            Spacer()

            // Success animation
            ZStack {
                Circle()
                    .fill(Theme.Colors.statusGreen.opacity(0.2))
                    .frame(width: 150, height: 150)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Theme.Colors.statusGreen)
                    .scaleEffect(showConfetti ? 1.0 : 0.5)
                    .animation(Theme.Animation.springBouncy, value: showConfetti)
            }

            // Text
            VStack(spacing: Theme.Spacing.md) {
                Text(viewModel.completeText)
                    .font(Theme.Typography.displaySmall)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text(viewModel.completeSubtext)
                    .font(Theme.Typography.bodyMedium)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.xl)
            }

            // Plant preview
            if let plantType = viewModel.selectedPlantType {
                VStack(spacing: Theme.Spacing.sm) {
                    PlantImageView(plantTypeId: plantType.id, size: .medium)

                    Text(viewModel.finalPlantName)
                        .font(Theme.Typography.plantName)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Text("Water every \(viewModel.wateringDays) days")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                .padding(Theme.Spacing.lg)
                .background(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.card)
                        .fill(Theme.Colors.cardBackground)
                        .themeShadow(Theme.Shadows.card)
                )
            }

            Spacer()

            // Button
            Button(action: onComplete) {
                Text("Let's Go!")
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, Theme.Spacing.screenPadding)
            .padding(.bottom, Theme.Spacing.xxl)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showConfetti = true
            }
        }
    }
}

// MARK: - Preview

#Preview {
    OnboardingView(
        viewModel: OnboardingViewModel(),
        onComplete: { _ in },
        onSkip: {}
    )
}
