import Foundation
import SwiftUI

// MARK: - Plant Library View Model
// Manages the plant selection and add plant flow

@Observable
final class PlantLibraryViewModel {
    // MARK: - Properties

    let allPlants: [PlantType] = PlantType.database
    var selectedPlantType: PlantType?
    var customName: String = ""
    var customWateringDays: Int = 7

    // Sheet states
    var showingPlantInfo = false
    var showingScheduleSetup = false
    var showingBypassWarning = false
    var bypassConfirmed = false

    // MARK: - Computed Properties

    var plantsByTier: [PlantTier: [PlantType]] {
        PlantType.groupedByTier
    }

    var availableTiers: [PlantTier] {
        PlantTier.allCases.filter { tier in
            !plants(forTier: tier).isEmpty
        }
    }

    // MARK: - Tier Methods

    func plants(forTier tier: PlantTier) -> [PlantType] {
        PlantType.plants(forTier: tier)
    }

    func isTierUnlocked(_ tier: PlantTier) -> Bool {
        UserPreferences.shared.isTierUnlocked(tier)
    }

    func isPlantUnlocked(_ plantType: PlantType) -> Bool {
        isTierUnlocked(plantType.tier)
    }

    func unlockRequirement(for tier: PlantTier) -> String {
        tier.unlockRequirement
    }

    func daysUntilUnlock(for tier: PlantTier) -> Int {
        let currentDays = UserPreferences.shared.longestPlantSurvival
        let required = tier.daysToUnlock
        return max(0, required - currentDays)
    }

    // MARK: - Selection Methods

    func selectPlant(_ plantType: PlantType) {
        selectedPlantType = plantType
        customName = ""
        customWateringDays = plantType.recommendedWateringDays
        bypassConfirmed = false

        if isPlantUnlocked(plantType) {
            showingPlantInfo = true
        } else {
            showingBypassWarning = true
        }
    }

    func proceedToSchedule() {
        showingPlantInfo = false
        showingScheduleSetup = true
    }

    func confirmBypass() {
        bypassConfirmed = true
        showingBypassWarning = false
        showingPlantInfo = true
    }

    func cancelBypass() {
        showingBypassWarning = false
        selectedPlantType = nil
        bypassConfirmed = false
    }

    func cancelSelection() {
        showingPlantInfo = false
        showingScheduleSetup = false
        showingBypassWarning = false
        selectedPlantType = nil
        customName = ""
        bypassConfirmed = false
    }

    // MARK: - Plant Creation

    func createPlant() -> Plant? {
        guard let plantType = selectedPlantType else { return nil }

        let name = customName.isEmpty ? plantType.commonName : customName
        let hasWarning = !isPlantUnlocked(plantType) && bypassConfirmed

        let plant = Plant(
            name: name,
            plantTypeId: plantType.id,
            wateringIntervalDays: customWateringDays,
            hasWarningBadge: hasWarning
        )

        // Reset state
        cancelSelection()

        return plant
    }

    // MARK: - Watering Options

    var wateringOptions: [Int] {
        [1, 2, 3, 4, 5, 6, 7, 10, 14, 21, 30]
    }

    func wateringLabel(for days: Int) -> String {
        switch days {
        case 1: return "Daily"
        case 7: return "Weekly"
        case 14: return "Every 2 weeks"
        case 21: return "Every 3 weeks"
        case 30: return "Monthly"
        default: return "Every \(days) days"
        }
    }

    // MARK: - Validation

    var canAddPlant: Bool {
        guard let plantType = selectedPlantType else { return false }
        return isPlantUnlocked(plantType) || bypassConfirmed
    }

    var plantLimitReached: Bool {
        !UserPreferences.shared.isPremium &&
        DataService.shared.loadPlants().count >= UserPreferences.shared.maxFreePlants
    }
}
