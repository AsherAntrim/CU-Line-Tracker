import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct InputLengthView: View {
    @Binding var pandaExpressLine: Int
    @Binding var chickFilALine: Int
    @Binding var chucksLine: Int

    @State private var selectedPlace: String = "Panda Express"
    @State private var newLineLength: Int = 1  // Changed to Int
    @State private var errorMessage: String = ""

    // Define custom colors for Gold and Blue
    let goldColor = Color(red: 231/255, green: 164/255, blue: 60/255) // Gold
    let blueColor = Color(red: 23/255, green: 37/255, blue: 54/255) // Blue
    let whiteColor = Color.white

    // Firebase Realtime Database reference
    let ref = Database.database().reference()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                Text("Update Line Length")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(blueColor)
                    .padding(.top, 40)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(errorMessage.contains("successfully") ? .green : .red)
                        .font(.caption)
                        .padding()
                }

                // Select Place Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("SELECT PLACE")
                        .font(.headline)
                        .foregroundColor(blueColor)
                    Picker("Place", selection: $selectedPlace) {
                        Text("Panda Express").tag("Panda Express")
                        Text("Chick-fil-A").tag("Chick-fil-A")
                        Text("Chuck's").tag("Chuck's")
                    }
                    .pickerStyle(WheelPickerStyle()) // Use WheelPickerStyle for a scrolling wheel effect
                    .background(whiteColor)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)

                // Line Length Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("LINE LENGTH (1 TO 10)")
                        .font(.headline)
                        .foregroundColor(blueColor)
                    Picker("Line Length", selection: $newLineLength) {
                        ForEach(1...10, id: \.self) { length in
                            Text("\(length)").tag(length)
                        }
                    }
                    .pickerStyle(WheelPickerStyle()) // Use WheelPickerStyle for the line length as well
                    .background(whiteColor)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)

                // Update Button
                Button(action: {
                    checkAndUpdateLineLength()
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
                .padding(.horizontal)
                .padding(.top, 20)

                Spacer()
            }
            .background(goldColor.edgesIgnoringSafeArea(.all))
            // Force light mode
            .preferredColorScheme(.light)
        }
    }

    private func checkAndUpdateLineLength() {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "You must be signed in to update."
            return
        }

        let currentTime = Int(Date().timeIntervalSince1970)
        let userId = user.uid
        let placeKey: String

        switch selectedPlace {
        case "Panda Express":
            placeKey = "pandaExpress"
        case "Chick-fil-A":
            placeKey = "chickFilA"
        case "Chuck's":
            placeKey = "chucks"
        default:
            return
        }

        // Fetch the last update timestamp for the user
        ref.child("userUpdates/\(userId)/\(placeKey)/lastUpdateTimestamp").observeSingleEvent(of: .value) { snapshot in
            if let lastUpdateTimestamp = snapshot.value as? Int {
                let timeSinceLastUpdate = currentTime - lastUpdateTimestamp
                if timeSinceLastUpdate < 300 { // 300 seconds = 5 minutes
                    self.errorMessage = "You can only update the line every 5 minutes."
                    return
                }
            }
            // Allow the update
            self.updateLineLength(for: placeKey, userId: userId, currentTime: currentTime)
        }
    }

    private func updateLineLength(for placeKey: String, userId: String, currentTime: Int) {
        let newUpdate: [String: Any] = [
            "lineLength": newLineLength,
            "timestamp": currentTime
        ]
        
        // Update the line length
        ref.child("lineLengths/\(placeKey)/latestUpdate").setValue(newUpdate) { error, _ in
            if let error = error {
                self.errorMessage = "Error updating line length: \(error.localizedDescription)"
            } else {
                // Update the user's last update timestamp
                ref.child("userUpdates/\(userId)/\(placeKey)/lastUpdateTimestamp").setValue(currentTime) { error, _ in
                    if let error = error {
                        self.errorMessage = "Error saving last update time: \(error.localizedDescription)"
                    } else {
                        self.errorMessage = "Line length updated successfully."
                    }
                }
            }
        }
    }
}

struct InputLengthView_Previews: PreviewProvider {
    static var previews: some View {
        InputLengthView(pandaExpressLine: .constant(5), chickFilALine: .constant(3), chucksLine: .constant(7))
    }
}
