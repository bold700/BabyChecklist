import SwiftUI

struct Activity: Identifiable {
    let id = UUID()
    let type: String
    let time: Date
}

struct ContentView: View {
    @State private var activities: [Activity] = []
    @State private var showingAddSleep = false
    @State private var showingAddFeeding = false
    @State private var vitaminGiven = false
    @State private var sleepStartTime = Date()
    @State private var sleepEndTime = Date()
    @State private var feedingTime = Date()
    
    var body: some View {
        NavigationStack {
            List {
                Section("Slaaptijden") {
                    ForEach(activities.filter { $0.type == "Slaap" }) { activity in
                        Text(activity.time.formatted())
                    }
                    Button("Slaaptijd toevoegen") {
                        showingAddSleep = true
                    }
                }
                
                Section("Drinktijden") {
                    ForEach(activities.filter { $0.type == "Drinken" }) { activity in
                        Text(activity.time.formatted())
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
                        DatePicker("Start tijd", selection: $sleepStartTime)
                        DatePicker("Eind tijd", selection: $sleepEndTime)
                    }
                    .navigationTitle("Slaaptijd toevoegen")
                    .toolbar {
                        Button("Gereed") {
                            activities.append(Activity(type: "Slaap", time: sleepStartTime))
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

#Preview {
    ContentView()
} 