import SwiftUI

struct DayOverviewView: View {
    let baby: Baby
    @ObservedObject var viewModel: BabyViewModel
    @State private var selectedDate = Date()
    @State private var showingSleepSheet = false
    @State private var showingFeedingSheet = false
    @State private var showingDiaperSheet = false
    
    var body: some View {
        List {
            // Slaaptijd sectie
            Section {
                ForEach(baby.sleepEntries.filter { Calendar.current.isDate($0.startTime, inSameDayAs: selectedDate) }) { entry in
                    HStack {
                        Image(systemName: "bed.double.fill")
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("Slaaptijd")
                                .font(.headline)
                            if let endTime = entry.endTime {
                                Text("\(entry.startTime.formatted(date: .omitted, time: .shortened)) - \(endTime.formatted(date: .omitted, time: .shortened))")
                            } else {
                                Text("Sinds \(entry.startTime.formatted(date: .omitted, time: .shortened))")
                            }
                        }
                    }
                }
                Button(action: { showingSleepSheet = true }) {
                    Label("Nieuwe slaaptijd", systemImage: "plus")
                }
            } header: {
                Text("🕒 Slaaptijden")
            }
            
            // Voeding sectie
            Section {
                ForEach(baby.feedingEntries.filter { Calendar.current.isDate($0.time, inSameDayAs: selectedDate) }) { entry in
                    HStack {
                        Image(systemName: "drop.fill")
                            .foregroundColor(.pink)
                        VStack(alignment: .leading) {
                            Text(entry.type.rawValue)
                                .font(.headline)
                            HStack {
                                Text(entry.time.formatted(date: .omitted, time: .shortened))
                                if let amount = entry.amount {
                                    Text("• \(amount)ml")
                                }
                            }
                        }
                    }
                }
                Button(action: { showingFeedingSheet = true }) {
                    Label("Nieuwe voeding", systemImage: "plus")
                }
            } header: {
                Text("🍼 Voedingen")
            }
            
            // Luier sectie
            Section {
                ForEach(baby.diaperEntries.filter { Calendar.current.isDate($0.time, inSameDayAs: selectedDate) }) { entry in
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.purple)
                        VStack(alignment: .leading) {
                            Text(entry.type.rawValue)
                                .font(.headline)
                            Text(entry.time.formatted(date: .omitted, time: .shortened))
                        }
                    }
                }
                Button(action: { showingDiaperSheet = true }) {
                    Label("Nieuwe luier", systemImage: "plus")
                }
            } header: {
                Text("🧼 Luiers")
            }
            
            // Vitamine sectie
            Section {
                ForEach(baby.vitaminEntries.filter { Calendar.current.isDate($0.time, inSameDayAs: selectedDate) }) { entry in
                    HStack {
                        Image(systemName: "pill.fill")
                            .foregroundColor(.orange)
                        VStack(alignment: .leading) {
                            Text("Vitamine D")
                                .font(.headline)
                            Text(entry.time.formatted(date: .omitted, time: .shortened))
                        }
                        Spacer()
                        if entry.given {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                }
                Button(action: { viewModel.addVitaminEntry(baby: baby) }) {
                    Label("Vitamine gegeven", systemImage: "plus")
                }
            } header: {
                Text("💊 Vitamines")
            }
        }
        .navigationTitle(baby.name)
        .toolbar {
            ToolbarItem(placement: .principal) {
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
        }
        .sheet(isPresented: $showingSleepSheet) {
            NewSleepEntryView(baby: baby, viewModel: viewModel)
        }
        .sheet(isPresented: $showingFeedingSheet) {
            NewFeedingEntryView(baby: baby, viewModel: viewModel)
        }
        .sheet(isPresented: $showingDiaperSheet) {
            NewDiaperEntryView(baby: baby, viewModel: viewModel)
        }
    }
}

struct NewSleepEntryView: View {
    let baby: Baby
    @ObservedObject var viewModel: BabyViewModel
    @Environment(\.dismiss) var dismiss
    @State private var startTime = Date()
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Start tijd", selection: $startTime)
            }
            .navigationTitle("Nieuwe slaaptijd")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuleren") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Toevoegen") {
                        viewModel.addSleepEntry(baby: baby, startTime: startTime)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct NewFeedingEntryView: View {
    let baby: Baby
    @ObservedObject var viewModel: BabyViewModel
    @Environment(\.dismiss) var dismiss
    @State private var type: FeedingType = .bottle
    @State private var amount: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Type voeding", selection: $type) {
                    Text("Fles").tag(FeedingType.bottle)
                    Text("Borstvoeding").tag(FeedingType.breast)
                    Text("Anders").tag(FeedingType.other)
                }
                TextField("Hoeveelheid (ml)", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Nieuwe voeding")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuleren") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Toevoegen") {
                        viewModel.addFeedingEntry(
                            baby: baby,
                            type: type,
                            amount: Int(amount)
                        )
                        dismiss()
                    }
                }
            }
        }
    }
}

struct NewDiaperEntryView: View {
    let baby: Baby
    @ObservedObject var viewModel: BabyViewModel
    @Environment(\.dismiss) var dismiss
    @State private var type: DiaperType = .wet
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Type luier", selection: $type) {
                    Text("Nat").tag(DiaperType.wet)
                    Text("Poep").tag(DiaperType.dirty)
                    Text("Beide").tag(DiaperType.both)
                }
            }
            .navigationTitle("Nieuwe luier")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuleren") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Toevoegen") {
                        viewModel.addDiaperEntry(baby: baby, type: type)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    DayOverviewView(
        baby: Baby(name: "Emma", birthDate: Date()),
        viewModel: BabyViewModel()
    )
} 