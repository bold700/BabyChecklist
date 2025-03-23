import SwiftUI

struct Activity: Identifiable {
    let id = UUID()
    let type: String
    let time: Date
}

struct ContentView: View {
    @AppStorage("activities") private var activitiesData: Data = Data()
    @AppStorage("vitaminGiven") private var vitaminGiven = false
    
    @State private var activities: [Activity] = []
    @State private var showingAddSleep = false
    @State private var showingAddFeeding = false
    @State private var sleepTime = Date()
    @State private var feedingTime = Date()
    
    var sortedActivities: [Activity] {
        activities.sorted { $0.time > $1.time }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Slaaptijden") {
                    ForEach(sortedActivities.filter { $0.type == "Slaap" }) { activity in
                        Text(activity.time.formatted(date: .abbreviated, time: .shortened))
                    }
                    Button("Slaaptijd toevoegen") {
                        showingAddSleep = true
                    }
                }
                
                Section("Drinktijden") {
                    ForEach(sortedActivities.filter { $0.type == "Drinken" }) { activity in
                        Text(activity.time.formatted(date: .abbreviated, time: .shortened))
                    }
                    Button("Drinktijd toevoegen") {
                        showingAddFeeding = true
                    }
                }
                
                Section("Vitamine") {
                    Toggle("Vitamine gegeven", isOn: $vitaminGiven)
                }
            }
            .navigationTitle("Baby Checklist")
            .sheet(isPresented: $showingAddSleep) {
                NavigationStack {
                    Form {
                        DatePicker("Tijd", selection: $sleepTime)
                    }
                    .navigationTitle("Slaaptijd toevoegen")
                    .toolbar {
                        Button("Gereed") {
                            activities.append(Activity(type: "Slaap", time: sleepTime))
                            showingAddSleep = false
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddFeeding) {
                NavigationStack {
                    Form {
                        DatePicker("Tijd", selection: $feedingTime)
                    }
                    .navigationTitle("Drinktijd toevoegen")
                    .toolbar {
                        Button("Gereed") {
                            activities.append(Activity(type: "Drinken", time: feedingTime))
                            showingAddFeeding = false
                        }
                    }
                }
            }
        }
    }
} 