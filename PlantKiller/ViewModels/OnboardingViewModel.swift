import Foundation
import SwiftUI

// MARK: - Onboarding View Model
// Manages the onboarding flow

@Observable
final class OnboardingViewModel {
    // MARK: - Onboarding Steps

    enum Step: Int, CaseIterable {
        case welcome = 0
        case killerQuestion = 1
        case plantSelection = 2
        case scheduleSetup = 3
        case namePlant = 4
        case complete = 5

        var title: String {
            switch self {
            case .welcome: return "Welcome to PlantKiller"
            case .killerQuestion: return "Let's be honest..."
            case .plantSelection: return "Choose Your First Plant"
            case .scheduleSetup: return "Set Your Schedule"
            case .namePlant: return "Name Your Plant"
            case .complete: return "You're All Set!"
            }
        }
    }

    // MARK: - Properties

    var currentStep: Step = .welcome
    var admittedKiller: Bool = false
    var selectedPlantType: PlantType?
    var wateringDays: Int = 7
    var plantName: String = ""

    // Animation states
    var showContent = false
    var isTransitioning = false

    // MARK: - Computed Properties

    var progress: Double {
        Double(currentStep.rawValue) / Double(Step.allCases.count - 1)
    }

    var canProceed: Bool {
        switch currentStep {
        case .welcome: return true
        case .killerQuestion: return true
        case .plantSelection: return selectedPlantType != nil
        case .scheduleSetup: return true
        case .namePlant: return true
        case .complete: return true
        }
    }

    var availablePlants: [PlantType] {
        // Only show beginner plants during onboarding
        PlantType.plants(forTier: .beginner)
    }

    var finalPlantName: String {
        plantName.isEmpty ? (selectedPlantType?.commonName ?? "Plant") : plantName
    }

    // MARK: - Navigation

    func nextStep() {
        guard canProceed else { return }

        isTransitioning = true

        withAnimation(Theme.Animation.easeInOut) {
            showContent = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }

            if let nextStep = Step(rawValue: currentStep.rawValue + 1) {
                currentStep = nextStep
            }

            withAnimation(Theme.Animation.easeInOut) {
                showContent = true
                isTransitioning = false
            }
        }
    }

    func previousStep() {
        guard currentStep.rawValue > 0 else { return }

        isTransitioning = true

        withAnimation(Theme.Animation.easeInOut) {
            showContent = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }

            if let prevStep = Step(rawValue: currentStep.rawValue - 1) {
                currentStep = prevStep
            }

            withAnimation(Theme.Animation.easeInOut) {
                showContent = true
                isTransitioning = false
            }
        }
    }

    func skipToComplete() {
        currentStep = .complete
    }

    // MARK: - Actions

    func selectPlant(_ plantType: PlantType) {
        selectedPlantType = plantType
        wateringDays = plantType.recommendedWateringDays
    }

    func answerKillerQuestion(admitted: Bool) {
        admittedKiller = admitted
        UserPreferences.shared.hasAnsweredKillerQuestion = true
        UserPreferences.shared.admittedPlantKiller = admitted
    }

    func createFirstPlant() -> Plant? {
        guard let plantType = selectedPlantType else { return nil }

        return Plant(
            name: finalPlantName,
            plantTypeId: plantType.id,
            wateringIntervalDays: wateringDays
        )
    }

    func completeOnboarding() {
        UserPreferences.shared.hasCompletedOnboarding = true
    }

    // MARK: - Content

    var killerQuestionText: String {
        "Have you ever killed a plant?"
    }

    var killerQuestionSubtext: String {
        "It's okay. We all have. That's why we're here."
    }

    var yesButtonText: String {
        "Yes, I'm a plant killer"
    }

    var noButtonText: String {
        "No, I'm a plant saint"
    }

    var welcomeText: String {
        "The Plant App for People Who Kill Plants"
    }

    var welcomeSubtext: String {
        "Finally, an app that gets it. Let's keep your plants alive this time."
    }

    var completeText: String {
        if admittedKiller {
            return "Redemption starts now!"
        } else {
            return "Let's see how long that lasts..."
        }
    }

    var completeSubtext: String {
        "We'll remind you when \(finalPlantName) needs water. No excuses this time."
    }

    // MARK: - Initialization

    func start() {
        currentStep = .welcome
        showContent = true
    }
}
