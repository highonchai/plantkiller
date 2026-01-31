import Foundation

// MARK: - Data Service
// Handles local data persistence using UserDefaults

final class DataService {
    // MARK: - Singleton

    static let shared = DataService()

    // MARK: - Keys

    private enum Keys {
        static let plants = "plants_data"
        static let graveyardEntries = "graveyard_entries_data"
    }

    // MARK: - Properties

    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // MARK: - Initialization

    private init() {}

    // MARK: - Plants

    func savePlants(_ plants: [Plant]) {
        do {
            let data = try encoder.encode(plants)
            defaults.set(data, forKey: Keys.plants)
        } catch {
            print("Error saving plants: \(error)")
        }
    }

    func loadPlants() -> [Plant] {
        guard let data = defaults.data(forKey: Keys.plants) else {
            return []
        }

        do {
            return try decoder.decode([Plant].self, from: data)
        } catch {
            print("Error loading plants: \(error)")
            return []
        }
    }

    func deletePlant(withId id: UUID) {
        var plants = loadPlants()
        plants.removeAll { $0.id == id }
        savePlants(plants)
    }

    func updatePlant(_ plant: Plant) {
        var plants = loadPlants()
        if let index = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[index] = plant
            savePlants(plants)
        }
    }

    // MARK: - Graveyard Entries

    func saveGraveyardEntries(_ entries: [GraveyardEntry]) {
        do {
            let data = try encoder.encode(entries)
            defaults.set(data, forKey: Keys.graveyardEntries)
        } catch {
            print("Error saving graveyard entries: \(error)")
        }
    }

    func loadGraveyardEntries() -> [GraveyardEntry] {
        guard let data = defaults.data(forKey: Keys.graveyardEntries) else {
            return []
        }

        do {
            return try decoder.decode([GraveyardEntry].self, from: data)
        } catch {
            print("Error loading graveyard entries: \(error)")
            return []
        }
    }

    func addGraveyardEntry(_ entry: GraveyardEntry) {
        var entries = loadGraveyardEntries()
        entries.append(entry)
        saveGraveyardEntries(entries)
    }

    func removeGraveyardEntry(withId id: UUID) {
        var entries = loadGraveyardEntries()
        entries.removeAll { $0.id == id }
        saveGraveyardEntries(entries)
    }

    // MARK: - Clear All Data

    func clearAllData() {
        defaults.removeObject(forKey: Keys.plants)
        defaults.removeObject(forKey: Keys.graveyardEntries)
        UserPreferences.shared.reset()
    }

    // MARK: - Export / Import (for future backup features)

    struct AppData: Codable {
        let plants: [Plant]
        let graveyardEntries: [GraveyardEntry]
        let exportDate: Date
    }

    func exportData() -> Data? {
        let appData = AppData(
            plants: loadPlants(),
            graveyardEntries: loadGraveyardEntries(),
            exportDate: Date()
        )

        do {
            return try encoder.encode(appData)
        } catch {
            print("Error exporting data: \(error)")
            return nil
        }
    }

    func importData(_ data: Data) -> Bool {
        do {
            let appData = try decoder.decode(AppData.self, from: data)
            savePlants(appData.plants)
            saveGraveyardEntries(appData.graveyardEntries)
            return true
        } catch {
            print("Error importing data: \(error)")
            return false
        }
    }
}
