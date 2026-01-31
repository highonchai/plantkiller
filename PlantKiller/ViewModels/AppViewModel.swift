import Foundation
import SwiftUI

// MARK: - App View Model
// Coordinates global app state and navigation

@Observable
final class AppViewModel {
    // MARK: - Singleton

    static let shared = AppViewModel()

    // MARK: - Child View Models

    let plantsViewModel: PlantsViewModel
    let graveyardViewModel: GraveyardViewModel
    let plantLibraryViewModel: PlantLibraryViewModel
    let onboardingViewModel: OnboardingViewModel

    // MARK: - Navigation State

    enum Tab: Int {
        case plants = 0
        case graveyard = 1
    }

    var selectedTab: Tab = .plants
    var showingAddPlant = false
    var showingSettings = false
    var showingOnboarding = false
    var showingPaywall = false

    // MARK: - Alert State

    var showingAlert = false
    var alertTitle = ""
    var alertMessage = ""

    // MARK: - Notification State

    var notificationsEnabled = true

    // MARK: - Computed Properties

    var shouldShowOnboarding: Bool {
        !UserPreferences.shared.hasCompletedOnboarding
    }

    var userPreferences: UserPreferences {
        UserPreferences.shared
    }

    // MARK: - Initialization

    private init() {
        self.plantsViewModel = PlantsViewModel()
        self.graveyardViewModel = GraveyardViewModel()
        self.plantLibraryViewModel = PlantLibraryViewModel()
        self.onboardingViewModel = OnboardingViewModel()

        checkNotificationStatus()
    }

    // MARK: - Navigation

    func showAddPlant() {
        if plantLibraryViewModel.plantLimitReached {
            showPaywall()
        } else {
            showingAddPlant = true
        }
    }

    func hideAddPlant() {
        showingAddPlant = false
        plantLibraryViewModel.cancelSelection()
    }

    func showSettings() {
        showingSettings = true
    }

    func hideSettings() {
        showingSettings = false
    }

    func showPaywall() {
        showingPaywall = true
    }

    func hidePaywall() {
        showingPaywall = false
    }

    // MARK: - Plant Actions

    func addPlant(_ plant: Plant) {
        plantsViewModel.addPlant(plant)
        hideAddPlant()
    }

    func waterPlant(_ plant: Plant) {
        plantsViewModel.waterPlant(plant)
    }

    func deletePlant(_ plant: Plant) {
        let entry = plantsViewModel.deletePlant(plant)
        graveyardViewModel.addEntry(entry)
        plantsViewModel.deselectPlant()
    }

    func killPlant(_ plant: Plant, cause: GraveyardEntry.CauseOfDeath) {
        let entry = plantsViewModel.killPlant(plant, cause: cause)
        graveyardViewModel.addEntry(entry)
        plantsViewModel.deselectPlant()
    }

    func resurrectPlant(from entry: GraveyardEntry) {
        graveyardViewModel.prepareForResurrection(entry)
        if let plant = plantsViewModel.resurrectPlant(from: entry) {
            showAlert(
                title: "Plant Resurrected!",
                message: "\(plant.name) has been brought back to life. Don't let it die again!"
            )
            selectedTab = .plants
        }
        graveyardViewModel.deselectEntry()
    }

    // MARK: - Onboarding

    func completeOnboarding(with plant: Plant) {
        plantsViewModel.addPlant(plant)
        onboardingViewModel.completeOnboarding()
        showingOnboarding = false
    }

    func skipOnboarding() {
        onboardingViewModel.completeOnboarding()
        showingOnboarding = false
    }

    // MARK: - Alerts

    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }

    // MARK: - Notifications

    func checkNotificationStatus() {
        NotificationService.shared.checkAuthorizationStatus { [weak self] enabled in
            DispatchQueue.main.async {
                self?.notificationsEnabled = enabled
            }
        }
    }

    func requestNotificationPermission() {
        NotificationService.shared.requestAuthorization { [weak self] granted in
            DispatchQueue.main.async {
                self?.notificationsEnabled = granted
            }
        }
    }

    // MARK: - Premium

    func upgradeToPremium() {
        UserPreferences.shared.isPremium = true
        hidePaywall()
    }

    func restorePurchases() {
        // Superwall integration would go here
        // For now, just toggle premium for testing
    }
}
