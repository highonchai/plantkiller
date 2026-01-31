import Foundation
import SwiftUI

// MARK: - Graveyard View Model
// Manages the dead plant memorial

@Observable
final class GraveyardViewModel {
    // MARK: - Properties

    private(set) var entries: [GraveyardEntry] = []
    private let dataService: DataService

    var selectedEntry: GraveyardEntry?
    var showingEntryDetail = false

    // MARK: - Computed Properties

    var isEmpty: Bool {
        entries.isEmpty
    }

    var totalDeaths: Int {
        entries.count
    }

    var resurrectionEligible: [GraveyardEntry] {
        entries.filter { $0.canResurrect }
    }

    var permanentlyDead: [GraveyardEntry] {
        entries.filter { !$0.canResurrect }
    }

    var sortedEntries: [GraveyardEntry] {
        // Show entries that can be resurrected first
        entries.sorted { entry1, entry2 in
            if entry1.canResurrect == entry2.canResurrect {
                return entry1.deathDate > entry2.deathDate
            }
            return entry1.canResurrect && !entry2.canResurrect
        }
    }

    var averageSurvivalDays: Int {
        guard !entries.isEmpty else { return 0 }
        let total = entries.reduce(0) { $0 + $1.daysSurvived }
        return total / entries.count
    }

    var longestSurvival: Int {
        entries.map { $0.daysSurvived }.max() ?? 0
    }

    // MARK: - Initialization

    init(dataService: DataService = .shared) {
        self.dataService = dataService
        loadEntries()
    }

    // MARK: - Data Management

    func loadEntries() {
        entries = dataService.loadGraveyardEntries()
        cleanupExpiredEntries()
    }

    private func saveEntries() {
        dataService.saveGraveyardEntries(entries)
    }

    private func cleanupExpiredEntries() {
        // Remove entries that have been permanently dead for more than 30 days
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        let originalCount = entries.count
        entries.removeAll { entry in
            !entry.canResurrect && entry.deathDate < thirtyDaysAgo
        }
        if entries.count != originalCount {
            saveEntries()
        }
    }

    // MARK: - Entry Actions

    func addEntry(_ entry: GraveyardEntry) {
        entries.append(entry)
        saveEntries()
    }

    func removeEntry(_ entry: GraveyardEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }

    func selectEntry(_ entry: GraveyardEntry) {
        selectedEntry = entry
        showingEntryDetail = true
    }

    func deselectEntry() {
        selectedEntry = nil
        showingEntryDetail = false
    }

    // MARK: - Resurrection

    func canResurrect(_ entry: GraveyardEntry) -> Bool {
        entry.canResurrect
    }

    func prepareForResurrection(_ entry: GraveyardEntry) {
        removeEntry(entry)
    }

    // MARK: - Statistics

    var statsText: String {
        if entries.isEmpty {
            return "No casualties yet - keep it that way!"
        }
        return "\(totalDeaths) plant\(totalDeaths == 1 ? "" : "s") lost, \(averageSurvivalDays) days avg survival"
    }

    var emptyStateMessage: String {
        "No dead plants yet - keep it that way!"
    }

    var emptyStateSubtitle: String {
        "Your graveyard is empty. Let's keep your plants alive!"
    }
}
