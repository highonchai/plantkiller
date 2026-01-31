import Foundation

// MARK: - Graveyard Entry
// Represents a dead plant in the memorial

struct GraveyardEntry: Identifiable, Codable, Equatable {
    let id: UUID
    let plantName: String
    let plantTypeId: String
    let deathDate: Date
    let daysSurvived: Int
    let resurrectionDeadline: Date
    let causeOfDeath: CauseOfDeath

    // MARK: - Cause of Death

    enum CauseOfDeath: String, Codable {
        case neglect = "Neglected"
        case overwatering = "Overwatered"
        case userDeleted = "Gave Up"
        case autoDeath = "Abandoned"
        case unknown = "Unknown Causes"

        var epitaph: String {
            switch self {
            case .neglect: return "Forgotten but not gone"
            case .overwatering: return "Loved too much"
            case .userDeleted: return "Rest in Peace"
            case .autoDeath: return "Left behind"
            case .unknown: return "Gone too soon"
            }
        }

        var snarkyMessage: String {
            switch self {
            case .neglect: return "You had ONE job..."
            case .overwatering: return "Drowning in your love"
            case .userDeleted: return "At least you admitted defeat"
            case .autoDeath: return "Out of sight, out of mind, out of life"
            case .unknown: return "A mystery for the ages"
            }
        }
    }

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        plantName: String,
        plantTypeId: String,
        deathDate: Date = Date(),
        daysSurvived: Int,
        causeOfDeath: CauseOfDeath = .neglect
    ) {
        self.id = id
        self.plantName = plantName
        self.plantTypeId = plantTypeId
        self.deathDate = deathDate
        self.daysSurvived = daysSurvived
        self.resurrectionDeadline = Calendar.current.date(byAdding: .day, value: 7, to: deathDate) ?? deathDate
        self.causeOfDeath = causeOfDeath
    }

    // MARK: - Factory Method

    static func from(plant: Plant, cause: CauseOfDeath = .neglect) -> GraveyardEntry {
        GraveyardEntry(
            plantName: plant.name,
            plantTypeId: plant.plantTypeId,
            deathDate: Date(),
            daysSurvived: plant.daysAlive,
            causeOfDeath: cause
        )
    }

    // MARK: - Computed Properties

    var plantType: PlantType? {
        PlantType.find(byId: plantTypeId)
    }

    var canResurrect: Bool {
        Date() < resurrectionDeadline
    }

    var daysUntilPermanentDeath: Int {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: resurrectionDeadline).day ?? 0
        return max(0, days)
    }

    var deathDateText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: deathDate)
    }

    var survivalText: String {
        switch daysSurvived {
        case 0: return "Didn't even last a day"
        case 1: return "Survived 1 day"
        case 2...7: return "Survived \(daysSurvived) days"
        case 8...30: return "Survived \(daysSurvived) days - not bad!"
        case 31...60: return "Survived \(daysSurvived) days - impressive!"
        default: return "Survived \(daysSurvived) days - a legend!"
        }
    }

    var resurrectionText: String {
        if canResurrect {
            return "\(daysUntilPermanentDeath) day\(daysUntilPermanentDeath == 1 ? "" : "s") left to resurrect"
        } else {
            return "Too late to resurrect"
        }
    }
}

// MARK: - Sample Data

extension GraveyardEntry {
    static let sampleEntries: [GraveyardEntry] = [
        GraveyardEntry(
            plantName: "Fernie",
            plantTypeId: "spider_plant",
            deathDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            daysSurvived: 12,
            causeOfDeath: .neglect
        ),
        GraveyardEntry(
            plantName: "Leafy",
            plantTypeId: "pothos",
            deathDate: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
            daysSurvived: 45,
            causeOfDeath: .userDeleted
        )
    ]
}
