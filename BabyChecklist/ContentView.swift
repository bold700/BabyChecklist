import SwiftUI

struct ContentView: View {
    @StateObject private var store = BabyStore()
    @State private var showingAddBaby = false
    
    var body: some View {
        NavigationStack {
            List(store.babies) { baby in
                NavigationLink {
                    BabyDetailView(baby: baby, store: store)
                } label: {
                    VStack(alignment: .leading) {
                        Text(baby.name)
                            .font(.headline)
                        Text(baby.birthDate.formatted(date: .abbreviated, time: .omitted))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Baby's")
            .toolbar {
                Button(action: { showingAddBaby = true }) {
                    Label("Baby toevoegen", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingAddBaby) {
                AddBabyView(store: store)
            }
        }
    }
}

struct AddBabyView: View {
    @ObservedObject var store: BabyStore
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var birthDate = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Naam", text: $name)
                DatePicker("Geboortedatum", selection: $birthDate, displayedComponents: .date)
            }
            .navigationTitle("Nieuwe baby")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuleren") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Toevoegen") {
                        store.addBaby(name: name, birthDate: birthDate)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct BabyDetailView: View {
    let baby: Baby
    @ObservedObject var store: BabyStore
    @State private var selectedActivityType: ActivityType?
    
    var body: some View {
        List {
            ForEach(ActivityType.allCases, id: \.self) { type in
                Section {
                    ForEach(baby.activities.filter { $0.type == type }) { activity in
                        HStack {
                            Image(systemName: type.icon)
                                .foregroundStyle(type.color)
                            VStack(alignment: .leading) {
                                Text(type.rawValue)
                                    .font(.headline)
                                Text(activity.timestamp.formatted(date: .omitted, time: .shortened))
                                    .font(.subheadline)
                                if let note = activity.note {
                                    Text(note)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    
                    Button(action: { selectedActivityType = type }) {
                        Label("Nieuwe \(type.rawValue.lowercased())", systemImage: "plus")
                    }
                } header: {
                    Label(type.rawValue, systemImage: type.icon)
                }
            }
        }
        .navigationTitle(baby.name)
        .sheet(item: $selectedActivityType) { type in
            AddActivityView(baby: baby, activityType: type, store: store)
        }
    }
}

struct AddActivityView: View {
    let baby: Baby
    let activityType: ActivityType
    @ObservedObject var store: BabyStore
    @Environment(\.dismiss) var dismiss
    @State private var note = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Notitie", text: $note)
            }
            .navigationTitle("Nieuwe \(activityType.rawValue.lowercased())")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuleren") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Toevoegen") {
                        store.addActivity(to: baby, type: activityType, note: note.isEmpty ? nil : note)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
} 