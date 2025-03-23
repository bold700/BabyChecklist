import Foundation

@MainActor
class BabyStore: ObservableObject {
    @Published private(set) var babies: [Baby] = []
    private let saveKey = "SavedBabies"
    
    init() {
        loadBabies()
    }
    
    func addBaby(name: String, birthDate: Date) {
        let baby = Baby(name: name, birthDate: birthDate)
        babies.append(baby)
        saveBabies()
    }
    
    func addActivity(to baby: Baby, type: ActivityType, note: String? = nil) {
        guard let index = babies.firstIndex(where: { $0.id == baby.id }) else { return }
        let activity = Activity(type: type, note: note)
        babies[index].activities.append(activity)
        saveBabies()
    }
    
    private func saveBabies() {
        if let encoded = try? JSONEncoder().encode(babies) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadBabies() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let decoded = try? JSONDecoder().decode([Baby].self, from: data)
        else { return }
        babies = decoded
    }
} 