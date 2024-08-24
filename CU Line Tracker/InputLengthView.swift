import SwiftUI
import FirebaseDatabase

struct InputLengthView: View {
    @Binding var pandaExpressLine: Int
    @Binding var chickFilALine: Int
    @Binding var chucksLine: Int

    @State private var selectedPlace: String = "Panda Express"
    @State private var newLineLength: Int = 1  // Changed to Int

    // Define custom colors for Gold and Blue
    let goldColor = Color(red: 231/255, green: 164/255, blue: 60/255) // Gold
    let blueColor = Color(red: 23/255, green: 37/255, blue: 54/255) // Blue
    let whiteColor = Color.white

    // Food places options
    let foodPlaces = ["Panda Express", "Chick-fil-A", "Chuck's"]

    // Firebase Realtime Database reference
    let ref = Database.database().reference()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                // Optional: Add Cedarville or other image/logo to fill space
                Image("cedarville") // Ensure this is in Assets.xcassets
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150) // Adjust height as necessary
                    .padding(.top, 20)

                // Main Heading
                Text("Update Line Length")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(blueColor)
                    .padding(.top, 10)

                // Select Place and Line Length Section with Wheel Pickers
                VStack(spacing: 30) {
                    // Food Place Picker (Wheel)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Place")
                            .font(.headline)
                            .foregroundColor(blueColor)
                        
                        Picker("Select Place", selection: $selectedPlace) {
                            ForEach(foodPlaces, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(WheelPickerStyle()) // Use wheel picker style
                        .frame(height: 100) // Adjust picker height
                        .clipped() // Prevent clipping of the picker
                        .background(whiteColor)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }

                    // Line Length Picker (Wheel)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Line Length (0 to 10)")
                            .font(.headline)
                            .foregroundColor(blueColor)
                        
                        Picker("Line Length", selection: $newLineLength) {
                            ForEach(0..<11) { number in
                                Text("\(number)").tag(number)
                            }
                        }
                        .pickerStyle(WheelPickerStyle()) // Use wheel picker style
                        .frame(height: 100) // Adjust picker height
                        .clipped() // Prevent clipping of the picker
                        .background(whiteColor)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }

                    // Update Button
                    Button(action: {
                        updateLineLength()
                    }) {
                        Text("Update")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(blueColor)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }
                .padding()
                .background(goldColor.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)

                Spacer(minLength: 50) // Add smaller spacer to reduce extra empty space
            }
            .background(goldColor.edgesIgnoringSafeArea(.all)) // Set the gold color as the background
        }
    }

    // Update the line length in Firebase Realtime Database
    private func updateLineLength() {
        let timestamp = Int(Date().timeIntervalSince1970) // Current Unix timestamp

        var path: String
        switch selectedPlace {
        case "Panda Express":
            path = "lineLengths/pandaExpress/latestUpdate"
        case "Chick-fil-A":
            path = "lineLengths/chickFilA/latestUpdate"
        case "Chuck's":
            path = "lineLengths/chucks/latestUpdate"
        default:
            return
        }

        // Create a new update entry (overwrite the existing entry)
        let newUpdate: [String: Any] = [
            "lineLength": newLineLength,
            "timestamp": timestamp
        ]

        // Overwrite the latest update in Firebase under the correct place
        ref.child(path).setValue(newUpdate) { error, _ in
            if let error = error {
                print("Error updating line length: \(error.localizedDescription)")
            } else {
                print("\(selectedPlace) line length updated successfully.")
            }
        }
    }
}

struct InputLengthView_Previews: PreviewProvider {
    static var previews: some View {
        InputLengthView(pandaExpressLine: .constant(5), chickFilALine: .constant(3), chucksLine: .constant(7))
    }
}
