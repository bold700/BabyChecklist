import SwiftUI

struct ActivityRow: View {
    let time: String
    let isPlanned: Bool
    
    var body: some View {
        Text(time)
            .foregroundColor(isPlanned ? .gray : .primary)
            .italic(isPlanned)
    }
}

struct AddActivityView: View {
    @Binding var isPresented: Bool
    let title: String
    let onAdd: (Date) -> Void
    @State private var selectedTime = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Tijd", selection: $selectedTime)
            }
            .navigationTitle(title)
            .toolbar {
                Button("Gereed") {
                    onAdd(selectedTime)
                    isPresented = false
                }
            }
        }
    }
}

struct PlanningView: View {
    @Binding var isPresented: Bool
    @Binding var sleepTimes: [String]
    @Binding var feedingTimes: [String]
    @State private var selectedTime = Date()
    
    private func timeString(_ date: Date) -> String {
        date.formatted(date: .omitted, time: .shortened)
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Geplande slaaptijden") {
                    ForEach(sleepTimes, id: \.self) { time in
                        Text(time)
                    }
                    .onDelete { indexSet in
                        sleepTimes.remove(atOffsets: indexSet)
                    }
                    
                    HStack {
                        DatePicker("Tijd", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        Button("Toevoegen") {
                            let time = timeString(selectedTime)
                            if !sleepTimes.contains(time) {
                                sleepTimes.append(time)
                                sleepTimes.sort()
                            }
                        }
                    }
                }
                
                Section("Geplande voedingen") {
                    ForEach(feedingTimes, id: \.self) { time in
                        Text(time)
                    }
                    .onDelete { indexSet in
                        feedingTimes.remove(atOffsets: indexSet)
                    }
                    
                    HStack {
                        DatePicker("Tijd", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        Button("Toevoegen") {
                            let time = timeString(selectedTime)
                            if !feedingTimes.contains(time) {
                                feedingTimes.append(time)
                                feedingTimes.sort()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Dagplanning")
            .toolbar {
                Button("Gereed") {
                    isPresented = false
                }
            }
        }
    }
}

struct ContentView: View {
    @AppStorage("vitaminGiven") private var vitaminGiven = false
    @AppStorage("sleepTimes") private var sleepTimesString = ""
    @AppStorage("feedingTimes") private var feedingTimesString = ""
    @State private var activities: [String] = []
    @State private var lastResetDate = ""
    
    @State private var showingAddSleep = false
    @State private var showingAddFeeding = false
    @State private var showingSettings = false
    
    private var sleepTimes: [String] {
        get { sleepTimesString.components(separatedBy: ",").filter { !$0.isEmpty } }
        set { sleepTimesString = newValue.joined(separator: ",") }
    }
    
    private var feedingTimes: [String] {
        get { feedingTimesString.components(separatedBy: ",").filter { !$0.isEmpty } }
        set { feedingTimesString = newValue.joined(separator: ",") }
    }
    
    private func loadData() {
        if let savedActivities = UserDefaults.standard.stringArray(forKey: "todayActivities") {
            activities = savedActivities
        }
        lastResetDate = UserDefaults.standard.string(forKey: "lastResetDate") ?? ""
    }
    
    private func saveData() {
        UserDefaults.standard.set(activities, forKey: "todayActivities")
        UserDefaults.standard.set(lastResetDate, forKey: "lastResetDate")
    }
    
    private func timeString(_ date: Date) -> String {
        date.formatted(date: .omitted, time: .shortened)
    }
    
    private func addActivity(type: String, time: Date) {
        activities.append("\(type)|\(timeString(time))")
        saveData()
    }
    
    private func resetIfNeeded() {
        let today = Date().formatted(.dateTime.year().month().day())
        if lastResetDate != today {
            activities = []
            vitaminGiven = false
            lastResetDate = today
            saveData()
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Slaaptijden vandaag") {
                    // Toon geplande tijden
                    ForEach(sleepTimes, id: \.self) { time in
                        ActivityRow(time: time, isPlanned: true)
                    }
                    
                    // Toon geregistreerde tijden
                    ForEach(activities.filter { $0.hasPrefix("slaap|") }, id: \.self) { activity in
                        if let time = activity.split(separator: "|").last {
                            ActivityRow(time: String(time), isPlanned: false)
                        }
                    }
                    Button("Slaaptijd toevoegen") {
                        showingAddSleep = true
                    }
                }
                
                Section("Voedingen vandaag") {
                    // Toon geplande tijden
                    ForEach(feedingTimes, id: \.self) { time in
                        ActivityRow(time: time, isPlanned: true)
                    }
                    
                    // Toon geregistreerde tijden
                    ForEach(activities.filter { $0.hasPrefix("voeding|") }, id: \.self) { activity in
                        if let time = activity.split(separator: "|").last {
                            ActivityRow(time: String(time), isPlanned: false)
                        }
                    }
                    Button("Voeding toevoegen") {
                        showingAddFeeding = true
                    }
                }
                
                Section("Vitamine") {
                    Toggle("Vitamine gegeven", isOn: $vitaminGiven)
                }
            }
            .navigationTitle("Baby Checklist")
            .toolbar {
                Button("Planning") {
                    showingSettings = true
                }
            }
            .onAppear {
                loadData()
                resetIfNeeded()
            }
            .sheet(isPresented: $showingAddSleep) {
                AddActivityView(
                    isPresented: $showingAddSleep,
                    title: "Slaaptijd toevoegen",
                    onAdd: { time in
                        addActivity(type: "slaap", time: time)
                    }
                )
            }
            .sheet(isPresented: $showingAddFeeding) {
                AddActivityView(
                    isPresented: $showingAddFeeding,
                    title: "Voeding toevoegen",
                    onAdd: { time in
                        addActivity(type: "voeding", time: time)
                    }
                )
            }
            .sheet(isPresented: $showingSettings) {
                PlanningView(
                    isPresented: $showingSettings,
                    sleepTimes: .init(
                        get: { sleepTimes },
                        set: { sleepTimes = $0 }
                    ),
                    feedingTimes: .init(
                        get: { feedingTimes },
                        set: { feedingTimes = $0 }
                    )
                )
            }
        }
    }
} 