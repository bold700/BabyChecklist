import Foundation

struct Baby: Identifiable, Codable {
    var id: UUID
    var name: String
    var birthDate: Date
    var sleepEntries: [SleepEntry]
    var feedingEntries: [FeedingEntry]
    var diaperEntries: [DiaperEntry]
    var vitaminEntries: [VitaminEntry]
    
    init(id: UUID = UUID(), name: String, birthDate: Date) {
        self.id = id
        self.name = name
        self.birthDate = birthDate
        self.sleepEntries = []
        self.feedingEntries = []
        self.diaperEntries = []
        self.vitaminEntries = []
    }
} 