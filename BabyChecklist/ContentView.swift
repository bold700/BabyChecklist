import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BabyViewModel()
    @State private var showingAddBaby = false
    
    var body: some View {
        NavigationSplitView {
            // Sidebar met baby's
            List(viewModel.babies) { baby in
                NavigationLink(value: baby) {
                    VStack(alignment: .leading) {
                        Text(baby.name)
                            .font(.headline)
                        Text(baby.birthDate.formatted(date: .abbreviated, time: .omitted))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Baby's")
            .toolbar {
                Button(action: { showingAddBaby = true }) {
                    Label("Baby toevoegen", systemImage: "plus")
                }
            }
        } detail: {
            if let baby = viewModel.selectedBaby {
                DayOverviewView(baby: baby, viewModel: viewModel)
            } else {
                Text("Selecteer een baby")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        }
        .sheet(isPresented: $showingAddBaby) {
            AddBabyView(viewModel: viewModel)
        }
    }
}

struct AddBabyView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: BabyViewModel
    
    @State private var name = ""
    @State private var birthDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Naam", text: $name)
                DatePicker("Geboortedatum", selection: $birthDate, displayedComponents: .date)
            }
            .navigationTitle("Baby toevoegen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuleren") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Toevoegen") {
                        viewModel.addBaby(name: name, birthDate: birthDate)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    ContentView()
} 