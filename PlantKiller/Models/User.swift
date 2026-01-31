import Foundation

// MARK: - User Preferences
// Device-local user preferences and progress

@Observable
final class UserPreferences {
    // MARK: - Singleton

    static let shared = UserPreferences()

    // MARK: - Keys

    private enum Keys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let notificationTime = "notificationTime"
        static let isPremium = "isPremium"
        static let longestPlantSurvival = "longestPlantSurvival"
        static let totalPlantsKilled = "totalPlantsKilled"
        static let hasAnsweredKillerQuestion = "hasAnsweredKillerQuestion"
        static let admittedPlantKiller = "admittedPlantKiller"
    }

    // MARK: - Properties

    var hasCompletedOnboarding: Bool {
        didSet { save() }
    }

    var notificationTime: Date {
        didSet { save() }
    }

    var isPremium: Bool {
        didSet { save() }
    }

    var longestPlantSurvival: Int {
        didSet { save() }
    }

    var totalPlantsKilled: Int {
        didSet { save() }
    }

    var hasAnsweredKillerQuestion: Bool {
        didSet { save() }
    }

    var admittedPlantKiller: Bool {
        didSet { save() }
    }

    // MARK: - Computed Properties

    var unlockedTiers: [PlantTier] {
        var tiers: [PlantTier] = [.beginner]

        if longestPlantSurvival >= 30 {
            tiers.append(.intermediate)
        }
        if longestPlantSurvival >= 60 {
            tiers.append(.advanced)
        }
        if longestPlantSurvival >= 90 {
            tiers.append(.expert)
        }

        return tiers
    }

    var highestUnlockedTier: PlantTier {
        unlockedTiers.max() ?? .beginner
    }

    func isTierUnlocked(_ tier: PlantTier) -> Bool {
        unlockedTiers.contains(tier)
    }

    var notificationTimeText: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: notificationTime)
    }

    var maxFreePlants: Int {
        2
    }

    // MARK: - Initialization

    private init() {
        let defaults = UserDefaults.standard

        self.hasCompletedOnboarding = defaults.bool(forKey: Keys.hasCompletedOnboarding)
        self.isPremium = defaults.bool(forKey: Keys.isPremium)
        self.longestPlantSurvival = defaults.integer(forKey: Keys.longestPlantSurvival)
        self.totalPlantsKilled = defaults.integer(forKey: Keys.totalPlantsKilled)
        self.hasAnsweredKillerQuestion = defaults.bool(forKey: Keys.hasAnsweredKillerQuestion)
        self.admittedPlantKiller = defaults.bool(forKey: Keys.admittedPlantKiller)

        // Default notification time: 9:00 AM
        if let savedTime = defaults.object(forKey: Keys.notificationTime) as? Date {
            self.notificationTime = savedTime
        } else {
            var components = DateComponents()
            components.hour = 9
            components.minute = 0
            self.notificationTime = Calendar.current.date(from: components) ?? Date()
        }
    }

    // MARK: - Persistence

    private func save() {
        let defaults = UserDefaults.standard
        defaults.set(hasCompletedOnboarding, forKey: Keys.hasCompletedOnboarding)
        defaults.set(notificationTime, forKey: Keys.notificationTime)
        defaults.set(isPremium, forKey: Keys.isPremium)
        defaults.set(longestPlantSurvival, forKey: Keys.longestPlantSurvival)
        defaults.set(totalPlantsKilled, forKey: Keys.totalPlantsKilled)
        defaults.set(hasAnsweredKillerQuestion, forKey: Keys.hasAnsweredKillerQuestion)
        defaults.set(admittedPlantKiller, forKey: Keys.admittedPlantKiller)
    }

    // MARK: - Methods

    func updateLongestSurvival(days: Int) {
        if days > longestPlantSurvival {
            longestPlantSurvival = days
        }
    }

    func incrementPlantsKilled() {
        totalPlantsKilled += 1
    }

    func reset() {
        hasCompletedOnboarding = false
        isPremium = false
        longestPlantSurvival = 0
        totalPlantsKilled = 0
        hasAnsweredKillerQuestion = false
        admittedPlantKiller = false

        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        notificationTime = Calendar.current.date(from: components) ?? Date()

        save()
    }
}

// MARK: - Subscription Status

enum SubscriptionStatus {
    case free
    case premium

    var displayName: String {
        switch self {
        case .free: return "Free"
        case .premium: return "Premium"
        }
    }

    var canAddUnlimitedPlants: Bool {
        self == .premium
    }
}
