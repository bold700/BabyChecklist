import Foundation
import SwiftUI

@MainActor
class BabyViewModel: ObservableObject {
    @Published var babies: [Baby] = []
    @Published var selectedBaby: Baby?
    
    private let saveKey = "SavedBabies"
    
    init() {
        loadBabies()
    }
    
    func addBaby(name: String, birthDate: Date) {
        let baby = Baby(name: name, birthDate: birthDate)
        babies.append(baby)
        selectedBaby = baby
        saveBabies()
    }
    
    func addSleepEntry(baby: Baby, startTime: Date) {
        guard let index = babies.firstIndex(where: { $0.id == baby.id }) else { return }
        let entry = SleepEntry(startTime: startTime)
        babies[index].sleepEntries.append(entry)
        saveBabies()
    }
    
    func addFeedingEntry(baby: Baby, type: FeedingType, amount: Int? = nil) {
        guard let index = babies.firstIndex(where: { $0.id == baby.id }) else { return }
        let entry = FeedingEntry(type: type, amount: amount)
        babies[index].feedingEntries.append(entry)
        saveBabies()
    }
    
    func addDiaperEntry(baby: Baby, type: DiaperType) {
        guard let index = babies.firstIndex(where: { $0.id == baby.id }) else { return }
        let entry = DiaperEntry(type: type)
        babies[index].diaperEntries.append(entry)
        saveBabies()
    }
    
    func addVitaminEntry(baby: Baby) {
        guard let index = babies.firstIndex(where: { $0.id == baby.id }) else { return }
        let entry = VitaminEntry()
        babies[index].vitaminEntries.append(entry)
        saveBabies()
    }
    
    private func saveBabies() {
        if let encoded = try? JSONEncoder().encode(babies) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadBabies() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Baby].self, from: data) {
                babies = decoded
                if !babies.isEmpty {
                    selectedBaby = babies[0]
                }
            }
        }
    }
} 