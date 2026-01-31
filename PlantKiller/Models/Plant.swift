import Foundation

// MARK: - Plant Status
// Represents the current health status of a plant

enum PlantStatus: Codable {
    case healthy      // Green - watered on time
    case needsWater   // Yellow - due for watering soon
    case critical     // Red - overdue for watering

    var displayText: String {
        switch self {
        case .healthy: return "Healthy"
        case .needsWater: return "Needs Water"
        case .critical: return "Critical!"
        }
    }
}

// MARK: - Plant
// Represents a user's plant instance

struct Plant: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    let plantTypeId: String
    var wateringIntervalDays: Int
    var lastWateredDate: Date
    let dateAdded: Date
    var hasWarningBadge: Bool  // For bypassed tier plants
    var userPhotoData: Data?

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        name: String,
        plantTypeId: String,
        wateringIntervalDays: Int,
        lastWateredDate: Date = Date(),
        dateAdded: Date = Date(),
        hasWarningBadge: Bool = false,
        userPhotoData: Data? = nil
    ) {
        self.id = id
        self.name = name
        self.plantTypeId = plantTypeId
        self.wateringIntervalDays = wateringIntervalDays
        self.lastWateredDate = lastWateredDate
        self.dateAdded = dateAdded
        self.hasWarningBadge = hasWarningBadge
        self.userPhotoData = userPhotoData
    }

    // MARK: - Computed Properties

    var plantType: PlantType? {
        PlantType.find(byId: plantTypeId)
    }

    var daysSinceLastWatered: Int {
        Calendar.current.dateComponents([.day], from: lastWateredDate, to: Date()).day ?? 0
    }

    var daysUntilNextWatering: Int {
        wateringIntervalDays - daysSinceLastWatered
    }

    var nextWateringDate: Date {
        Calendar.current.date(byAdding: .day, value: wateringIntervalDays, to: lastWateredDate) ?? Date()
    }

    var status: PlantStatus {
        let daysOverdue = -daysUntilNextWatering
        if daysOverdue >= 2 {
            return .critical
        } else if daysOverdue >= 0 {
            return .needsWater
        } else {
            return .healthy
        }
    }

    var lastWateredText: String {
        let days = daysSinceLastWatered
        switch days {
        case 0: return "Watered today"
        case 1: return "Watered yesterday"
        default: return "Watered \(days) days ago"
        }
    }

    var nextWateringText: String {
        let days = daysUntilNextWatering
        switch days {
        case ...(-1): return "Overdue by \(abs(days)) day\(abs(days) == 1 ? "" : "s")!"
        case 0: return "Water today!"
        case 1: return "Water tomorrow"
        default: return "Water in \(days) days"
        }
    }

    var daysAlive: Int {
        Calendar.current.dateComponents([.day], from: dateAdded, to: Date()).day ?? 0
    }

    // MARK: - Methods

    mutating func water() {
        lastWateredDate = Date()
    }

    mutating func updateSchedule(days: Int) {
        wateringIntervalDays = days
    }

    mutating func rename(to newName: String) {
        name = newName
    }
}

// MARK: - Sample Data

extension Plant {
    static let samplePlants: [Plant] = [
        Plant(
            name: "Gerald",
            plantTypeId: "pothos",
            wateringIntervalDays: 7,
            lastWateredDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            dateAdded: Calendar.current.date(byAdding: .day, value: -45, to: Date())!
        ),
        Plant(
            name: "Snakey",
            plantTypeId: "snake_plant",
            wateringIntervalDays: 14,
            lastWateredDate: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
            dateAdded: Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        ),
        Plant(
            name: "Monty",
            plantTypeId: "monstera",
            wateringIntervalDays: 7,
            lastWateredDate: Calendar.current.date(byAdding: .day, value: -8, to: Date())!,
            dateAdded: Calendar.current.date(byAdding: .day, value: -20, to: Date())!,
            hasWarningBadge: true
        )
    ]
}
