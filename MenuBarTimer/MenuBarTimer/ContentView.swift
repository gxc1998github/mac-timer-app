
import SwiftUI

struct ContentView: View {
    @State private var selectedTime: Double = 0.0

    var body: some View {
        VStack {
            Text("Menu Bar Timer")
                .font(.headline)
            Slider(value: $selectedTime, in: 0...120, step: 1)
                .padding()
            Text("Selected Time: \(Int(selectedTime)) minutes")
            Button("Start Timer") {
                // Implement start timer logic here
            }
            .disabled(selectedTime == 0)
            .padding()
        }
        .frame(width: 200, height: 150)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
