import Foundation
import SwiftUI

// MARK: - Plants View Model
// Manages the user's active plants

@Observable
final class PlantsViewModel {
    // MARK: - Properties

    private(set) var plants: [Plant] = []
    private let dataService: DataService

    var selectedPlant: Plant?
    var showingPlantDetail = false
    var showingEditSheet = false
    var showingDeleteConfirmation = false

    // MARK: - Computed Properties

    var plantsNeedingWater: [Plant] {
        plants.filter { $0.status != .healthy }
    }

    var criticalPlants: [Plant] {
        plants.filter { $0.status == .critical }
    }

    var healthyPlants: [Plant] {
        plants.filter { $0.status == .healthy }
    }

    var plantCount: Int {
        plants.count
    }

    var isEmpty: Bool {
        plants.isEmpty
    }

    var canAddMorePlants: Bool {
        UserPreferences.shared.isPremium || plantCount < UserPreferences.shared.maxFreePlants
    }

    var sortedPlants: [Plant] {
        plants.sorted { plant1, plant2 in
            // Critical plants first, then needs water, then healthy
            if plant1.status == plant2.status {
                return plant1.daysUntilNextWatering < plant2.daysUntilNextWatering
            }
            return plant1.status.priority < plant2.status.priority
        }
    }

    // MARK: - Initialization

    init(dataService: DataService = .shared) {
        self.dataService = dataService
        loadPlants()
    }

    // MARK: - Data Management

    func loadPlants() {
        plants = dataService.loadPlants()
    }

    private func savePlants() {
        dataService.savePlants(plants)
        updateUserProgress()
    }

    private func updateUserProgress() {
        // Update longest survival record
        for plant in plants {
            UserPreferences.shared.updateLongestSurvival(days: plant.daysAlive)
        }
    }

    // MARK: - Plant Actions

    func addPlant(_ plant: Plant) {
        plants.append(plant)
        savePlants()
    }

    func waterPlant(_ plant: Plant) {
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[index].water()
        savePlants()
    }

    func waterPlant(withId id: UUID) {
        guard let index = plants.firstIndex(where: { $0.id == id }) else { return }
        plants[index].water()
        savePlants()
    }

    func updatePlant(_ updatedPlant: Plant) {
        guard let index = plants.firstIndex(where: { $0.id == updatedPlant.id }) else { return }
        plants[index] = updatedPlant
        savePlants()
    }

    func renamePlant(_ plant: Plant, to newName: String) {
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[index].rename(to: newName)
        savePlants()
    }

    func updateSchedule(for plant: Plant, days: Int) {
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[index].updateSchedule(days: days)
        savePlants()
    }

    func deletePlant(_ plant: Plant) -> GraveyardEntry {
        plants.removeAll { $0.id == plant.id }
        savePlants()
        UserPreferences.shared.incrementPlantsKilled()
        return GraveyardEntry.from(plant: plant, cause: .userDeleted)
    }

    func killPlant(_ plant: Plant, cause: GraveyardEntry.CauseOfDeath = .neglect) -> GraveyardEntry {
        plants.removeAll { $0.id == plant.id }
        savePlants()
        UserPreferences.shared.incrementPlantsKilled()
        return GraveyardEntry.from(plant: plant, cause: cause)
    }

    func resurrectPlant(from entry: GraveyardEntry) -> Plant? {
        guard let plantType = entry.plantType else { return nil }

        let plant = Plant(
            name: entry.plantName,
            plantTypeId: entry.plantTypeId,
            wateringIntervalDays: plantType.recommendedWateringDays,
            lastWateredDate: Date()
        )

        addPlant(plant)
        return plant
    }

    // MARK: - Selection

    func selectPlant(_ plant: Plant) {
        selectedPlant = plant
        showingPlantDetail = true
    }

    func deselectPlant() {
        selectedPlant = nil
        showingPlantDetail = false
    }

    // MARK: - Notifications Helper

    func plantsForNotification() -> [Plant] {
        plants.filter { $0.daysUntilNextWatering <= 0 }
    }
}

// MARK: - Plant Status Priority Extension

private extension PlantStatus {
    var priority: Int {
        switch self {
        case .critical: return 0
        case .needsWater: return 1
        case .healthy: return 2
        }
    }
}
