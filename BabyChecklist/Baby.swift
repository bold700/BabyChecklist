import Foundation
import SwiftUI

struct Baby: Identifiable, Codable {
    let id = UUID()
    var name: String
    var birthDate: Date
    var activities: [Activity] = []
    
    init(name: String, birthDate: Date) {
        self.name = name
        self.birthDate = birthDate
    }
}

struct Activity: Identifiable, Codable {
    let id = UUID()
    let type: ActivityType
    let timestamp: Date
    var note: String?
    
    init(type: ActivityType, timestamp: Date = Date(), note: String? = nil) {
        self.type = type
        self.timestamp = timestamp
        self.note = note
    }
}

enum ActivityType: String, Codable, CaseIterable {
    case sleep = "Slaap"
    case feed = "Voeding"
    case diaper = "Luier"
    case vitamin = "Vitamine"
    
    var icon: String {
        switch self {
        case .sleep: return "bed.double.fill"
        case .feed: return "drop.fill"
        case .diaper: return "heart.fill"
        case .vitamin: return "pill.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .sleep: return .blue
        case .feed: return .pink
        case .diaper: return .purple
        case .vitamin: return .orange
        }
    }
} 