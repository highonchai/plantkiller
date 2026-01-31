import SwiftUI

// MARK: - Plant Tier
// Represents difficulty tiers in the plant library

enum PlantTier: Int, Codable, CaseIterable, Comparable {
    case beginner = 1
    case intermediate = 2
    case advanced = 3
    case expert = 4

    // MARK: - Properties

    var displayName: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        case .expert: return "Expert"
        }
    }

    var description: String {
        switch self {
        case .beginner: return "Perfect for plant newbies"
        case .intermediate: return "A bit more attention needed"
        case .advanced: return "For experienced plant parents"
        case .expert: return "Master level difficulty"
        }
    }

    var unlockRequirement: String {
        switch self {
        case .beginner: return "Unlocked by default"
        case .intermediate: return "Keep plants alive for 30 days"
        case .advanced: return "Keep plants alive for 60 days"
        case .expert: return "Coming soon"
        }
    }

    var daysToUnlock: Int {
        switch self {
        case .beginner: return 0
        case .intermediate: return 30
        case .advanced: return 60
        case .expert: return 90
        }
    }

    var color: Color {
        switch self {
        case .beginner: return Theme.Colors.tierBeginner
        case .intermediate: return Theme.Colors.tierIntermediate
        case .advanced: return Theme.Colors.tierAdvanced
        case .expert: return Theme.Colors.tierExpert
        }
    }

    var iconName: String {
        switch self {
        case .beginner: return "leaf.fill"
        case .intermediate: return "leaf.arrow.triangle.circlepath"
        case .advanced: return "sparkles"
        case .expert: return "crown.fill"
        }
    }

    // MARK: - Comparable

    static func < (lhs: PlantTier, rhs: PlantTier) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
