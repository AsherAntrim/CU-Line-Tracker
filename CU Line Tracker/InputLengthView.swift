import SwiftUI

struct InputLengthView: View {
    @Binding var pandaExpressLine: Int
    @Binding var chickFilALine: Int
    @Binding var chucksLine: Int

    @State private var selectedPlace: String = "Panda Express"
    @State private var newLineLength: Int = 1  // Changed to Int

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Place")) {
                    Picker("Place", selection: $selectedPlace) {
                        Text("Panda Express").tag("Panda Express")
                        Text("Chick-fil-A").tag("Chick-fil-A")
                        Text("Chuck's").tag("Chuck's")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Line Length (1 to 10)")) {
                    Stepper(value: $newLineLength, in: 1...10, step: 1) {
                        Text("Line Length: \(newLineLength)")
                    }
                }

                Button(action: {
                    updateLineLength()
                }) {
                    Text("Update")
                        .font(.body)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("CedarvilleBlue"))
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Update Line Length")
            .background(Color("CedarvilleGold").edgesIgnoringSafeArea(.all))
        }
    }

    private func updateLineLength() {
        switch selectedPlace {
        case "Panda Express":
            pandaExpressLine = newLineLength
        case "Chick-fil-A":
            chickFilALine = newLineLength
        case "Chuck's":
            chucksLine = newLineLength
        default:
            break
        }
    }
}

struct InputLengthView_Previews: PreviewProvider {
    static var previews: some View {
        InputLengthView(pandaExpressLine: .constant(5), chickFilALine: .constant(3), chucksLine: .constant(7))
    }
}
