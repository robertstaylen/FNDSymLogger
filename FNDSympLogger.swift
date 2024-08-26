import SwiftUI

struct Symptom: Identifiable {
    let id = UUID()
    let name: String
    let trigger: String?
}

class SymptomLogger: ObservableObject {
    @Published var symptoms: [Symptom] = []

    func logSymptom(_ symptom: Symptom) {
        symptoms.append(symptom)
    }

    var topTriggers: [String] {
        symptoms.compactMap { $0.trigger }.sorted().groupBy { $0 }.map { $0.key }.prefix(3)
    }
}

struct ContentView: View {
    @StateObject var logger = SymptomLogger()

    var body: some View {
        VStack {
            List {
                ForEach(logger.symptoms) { symptom in
                    Text(symptom.name)
                    if let trigger = symptom.trigger {
                        Text(trigger)
                    }
                }
            }
            Button("Log New Symptom") {
                let newSymptom = Symptom(name: "New Symptom", trigger: "New Trigger")
                logger.logSymptom(newSymptom)
            }
            Text("Top Triggers:")
            ForEach(logger.topTriggers, id: \.self) { trigger in
                Text(trigger)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}