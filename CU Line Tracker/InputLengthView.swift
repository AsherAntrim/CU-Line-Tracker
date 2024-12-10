import SwiftUI

struct InputLengthView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    @State private var selectedPlace: String = "Panda Express"
    @State private var newLineLength: Int = 1
    @State private var updateMessage: String = ""
    @State private var isUpdating = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                Text("Update Line Length")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.blue)
                    .padding(.top, 40)
                
                if !updateMessage.isEmpty {
                    Text(updateMessage)
                        .foregroundColor(updateMessage.contains("successfully") ? .green : .red)
                        .font(.caption)
                        .padding()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("SELECT PLACE")
                        .font(.headline)
                        .foregroundColor(AppColors.blue)
                    Picker("Place", selection: $selectedPlace) {
                        Text("Panda Express").tag("Panda Express")
                        Text("Chick-fil-A").tag("Chick-fil-A")
                        Text("Chuck's").tag("Chuck's")
                        Text("The Café").tag("The Café") // NEW ENTRY
                    }
                    .pickerStyle(WheelPickerStyle())
                    .background(AppColors.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("LINE LENGTH (1 TO 10)")
                        .font(.headline)
                        .foregroundColor(AppColors.blue)
                    Picker("Line Length", selection: $newLineLength) {
                        ForEach(1...10, id: \.self) { length in
                            Text("\(length)").tag(length)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .background(AppColors.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)
                
                if isUpdating {
                    ProgressView("Updating...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .foregroundColor(.white)
                } else {
                    Button(action: {
                        updateLineLength()
                    }) {
                        Text("Update")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppColors.blue)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
                
                Spacer()
            }
            .background(AppColors.gold.edgesIgnoringSafeArea(.all))
            .preferredColorScheme(.light)
        }
    }
    
    private func updateLineLength() {
        guard let _ = viewModel.currentUser else {
            updateMessage = "You must be signed in to update."
            return
        }
        
        let placeKey: String
        switch selectedPlace {
        case "Panda Express": placeKey = "pandaExpress"
        case "Chick-fil-A":   placeKey = "chickFilA"
        case "Chuck's":       placeKey = "chucks"
        case "The Café":      placeKey = "theCafe" 
        default: return
        }
        
        isUpdating = true
        viewModel.updateLineLength(placeKey: placeKey, newLength: newLineLength) { success, message in
            DispatchQueue.main.async {
                self.isUpdating = false
                self.updateMessage = message
            }
        }
    }
}
