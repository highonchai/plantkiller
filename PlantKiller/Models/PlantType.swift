import Foundation

// MARK: - Plant Type
// Static database of plant types available in the app

struct PlantType: Identifiable, Codable, Equatable {
    let id: String
    let commonName: String
    let scientificName: String
    let tier: PlantTier
    let recommendedWateringDays: Int
    let careTips: String
    let description: String
    let imageName: String

    // MARK: - Computed Properties

    var wateringFrequencyText: String {
        if recommendedWateringDays == 1 {
            return "Daily"
        } else if recommendedWateringDays == 7 {
            return "Weekly"
        } else if recommendedWateringDays == 14 {
            return "Every 2 weeks"
        } else {
            return "Every \(recommendedWateringDays) days"
        }
    }

    var difficultyStars: Int {
        tier.rawValue
    }
}

// MARK: - Plant Database
// MVP includes 10 plants: 4 beginner, 4 intermediate, 2 advanced

extension PlantType {
    static let database: [PlantType] = [
        // Tier 1: Beginner (4 plants)
        PlantType(
            id: "pothos",
            commonName: "Pothos",
            scientificName: "Epipremnum aureum",
            tier: .beginner,
            recommendedWateringDays: 7,
            careTips: "Let soil dry between waterings. Tolerates low light. Perfect for beginners!",
            description: "The ultimate beginner plant. Pothos can survive almost anything and will forgive you for forgetting about it.",
            imageName: "plant_pothos"
        ),
        PlantType(
            id: "snake_plant",
            commonName: "Snake Plant",
            scientificName: "Sansevieria trifasciata",
            tier: .beginner,
            recommendedWateringDays: 14,
            careTips: "Water sparingly. Can go weeks without water. Prefers indirect light.",
            description: "Nearly indestructible. If you kill this one, you might want to reconsider having plants.",
            imageName: "plant_snake"
        ),
        PlantType(
            id: "spider_plant",
            commonName: "Spider Plant",
            scientificName: "Chlorophytum comosum",
            tier: .beginner,
            recommendedWateringDays: 7,
            careTips: "Keep soil slightly moist. Loves bright, indirect light. Produces cute babies!",
            description: "Forgiving and fun, spider plants bounce back quickly and make babies for your friends.",
            imageName: "plant_spider"
        ),
        PlantType(
            id: "zz_plant",
            commonName: "ZZ Plant",
            scientificName: "Zamioculcas zamiifolia",
            tier: .beginner,
            recommendedWateringDays: 14,
            careTips: "Drought tolerant. Water only when completely dry. Low light champion.",
            description: "The plant that thrives on neglect. Actually prefers if you forget about it sometimes.",
            imageName: "plant_zz"
        ),

        // Tier 2: Intermediate (4 plants)
        PlantType(
            id: "monstera",
            commonName: "Monstera",
            scientificName: "Monstera deliciosa",
            tier: .intermediate,
            recommendedWateringDays: 7,
            careTips: "Water when top inch is dry. Bright indirect light. Clean leaves monthly.",
            description: "The Instagram famous plant. Dramatic leaves require a bit more attention.",
            imageName: "plant_monstera"
        ),
        PlantType(
            id: "peace_lily",
            commonName: "Peace Lily",
            scientificName: "Spathiphyllum",
            tier: .intermediate,
            recommendedWateringDays: 5,
            careTips: "Dramatic drooper - wilts when thirsty but recovers fast. Keep soil moist.",
            description: "Will dramatically wilt to guilt you into watering it. Very effective communication.",
            imageName: "plant_peace_lily"
        ),
        PlantType(
            id: "rubber_plant",
            commonName: "Rubber Plant",
            scientificName: "Ficus elastica",
            tier: .intermediate,
            recommendedWateringDays: 7,
            careTips: "Water when top soil is dry. Wipe leaves to keep them shiny. Moderate light.",
            description: "Sturdy and stylish, but doesn't like to be moved around. Pick a spot and commit.",
            imageName: "plant_rubber"
        ),
        PlantType(
            id: "philodendron",
            commonName: "Philodendron",
            scientificName: "Philodendron hederaceum",
            tier: .intermediate,
            recommendedWateringDays: 7,
            careTips: "Let soil dry slightly between waterings. Thrives in medium to bright light.",
            description: "Gorgeous trailing vines that are fairly forgiving but need consistent care.",
            imageName: "plant_philodendron"
        ),

        // Tier 3: Advanced (2 plants)
        PlantType(
            id: "fiddle_leaf_fig",
            commonName: "Fiddle Leaf Fig",
            scientificName: "Ficus lyrata",
            tier: .advanced,
            recommendedWateringDays: 7,
            careTips: "Consistent watering crucial. Bright indirect light. Hates being moved!",
            description: "Beautiful but temperamental. Will drop leaves to express disappointment in you.",
            imageName: "plant_fiddle_leaf"
        ),
        PlantType(
            id: "calathea",
            commonName: "Calathea",
            scientificName: "Calathea ornata",
            tier: .advanced,
            recommendedWateringDays: 5,
            careTips: "Keep soil consistently moist. High humidity needed. Use filtered water.",
            description: "Stunning patterns but very picky about water quality and humidity. The diva of plants.",
            imageName: "plant_calathea"
        )
    ]

    // MARK: - Helper Methods

    static func find(byId id: String) -> PlantType? {
        database.first { $0.id == id }
    }

    static func plants(forTier tier: PlantTier) -> [PlantType] {
        database.filter { $0.tier == tier }
    }

    static var groupedByTier: [PlantTier: [PlantType]] {
        Dictionary(grouping: database, by: { $0.tier })
    }
}
