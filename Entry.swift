import Foundation

struct SleepEntry: Identifiable, Codable {
    var id: UUID
    var startTime: Date
    var endTime: Date?
    var notes: String?
    
    init(id: UUID = UUID(), startTime: Date = Date(), endTime: Date? = nil, notes: String? = nil) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.notes = notes
    }
}

enum FeedingType: String, Codable {
    case bottle = "Fles"
    case breast = "Borstvoeding"
    case other = "Anders"
}

struct FeedingEntry: Identifiable, Codable {
    var id: UUID
    var time: Date
    var type: FeedingType
    var amount: Int?
    var notes: String?
    
    init(id: UUID = UUID(), time: Date = Date(), type: FeedingType, amount: Int? = nil, notes: String? = nil) {
        self.id = id
        self.time = time
        self.type = type
        self.amount = amount
        self.notes = notes
    }
}

enum DiaperType: String, Codable {
    case wet = "Nat"
    case dirty = "Poep"
    case both = "Beide"
}

struct DiaperEntry: Identifiable, Codable {
    var id: UUID
    var time: Date
    var type: DiaperType
    var notes: String?
    
    init(id: UUID = UUID(), time: Date = Date(), type: DiaperType, notes: String? = nil) {
        self.id = id
        self.time = time
        self.type = type
        self.notes = notes
    }
}

struct VitaminEntry: Identifiable, Codable {
    var id: UUID
    var time: Date
    var given: Bool
    var notes: String?
    
    init(id: UUID = UUID(), time: Date = Date(), given: Bool = true, notes: String? = nil) {
        self.id = id
        self.time = time
        self.given = given
        self.notes = notes
    }
} 