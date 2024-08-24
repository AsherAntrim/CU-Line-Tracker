import SwiftUI
import FirebaseDatabase

struct LineLengthView: View {
    @Binding var pandaExpressLine: Int
    @Binding var chickFilALine: Int
    @Binding var chucksLine: Int

    @State private var lastUpdatedPandaExpress = "N/A"
    @State private var lastUpdatedChickFilA = "N/A"
    @State private var lastUpdatedChucks = "N/A"

    // Define custom colors for Gold and Blue
    let goldColor = Color(red: 231/255, green: 164/255, blue: 60/255) // Gold
    let blueColor = Color(red: 23/255, green: 37/255, blue: 54/255) // Blue
    let whiteColor = Color.white

    let ref = Database.database().reference()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image("cedarvillelogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200) // Adjust size as needed
                    .padding()
                
                Text("Current Line Lengths")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                    .foregroundColor(blueColor)

                ScrollView {
                    VStack(spacing: 15) {
                        lineDisplayView(place: "Panda Express", lineLength: pandaExpressLine, lastUpdated: lastUpdatedPandaExpress)
                        lineDisplayView(place: "Chick-fil-A", lineLength: chickFilALine, lastUpdated: lastUpdatedChickFilA)
                        lineDisplayView(place: "Chuck's", lineLength: chucksLine, lastUpdated: lastUpdatedChucks)
                    }
                    .padding()
                    .background(goldColor)
                    .cornerRadius(12)
                }
                .refreshable {
                    // Fetch the latest data when user pulls to refresh
                    fetchLatestLineLength(for: "pandaExpress", binding: $pandaExpressLine, lastUpdatedBinding: $lastUpdatedPandaExpress)
                    fetchLatestLineLength(for: "chickFilA", binding: $chickFilALine, lastUpdatedBinding: $lastUpdatedChickFilA)
                    fetchLatestLineLength(for: "chucks", binding: $chucksLine, lastUpdatedBinding: $lastUpdatedChucks)
                }

            }
            .background(goldColor.edgesIgnoringSafeArea(.all))
            .onAppear {
                fetchLatestLineLength(for: "pandaExpress", binding: $pandaExpressLine, lastUpdatedBinding: $lastUpdatedPandaExpress)
                fetchLatestLineLength(for: "chickFilA", binding: $chickFilALine, lastUpdatedBinding: $lastUpdatedChickFilA)
                fetchLatestLineLength(for: "chucks", binding: $chucksLine, lastUpdatedBinding: $lastUpdatedChucks)
            }
        }
    }

    private func lineDisplayView(place: String, lineLength: Int, lastUpdated: String) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(place):")
                    .font(.headline)
                    .foregroundColor(blueColor)
                Spacer()
                Text("\(lineLength)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(blueColor)
            }
            Text("Last updated: \(lastUpdated)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white.opacity(0.8)) // Light background for clarity
        .cornerRadius(10)
    }

    // Fetch the latest line length by iterating through updates and finding the most recent timestamp
    private func fetchLatestLineLength(for place: String, binding: Binding<Int>, lastUpdatedBinding: Binding<String>) {
        let path = "lineLengths/\(place)/latestUpdate"
        
        ref.child(path).observeSingleEvent(of: .value) { snapshot in
            print("Snapshot for \(place): \(snapshot)")

            guard let update = snapshot.value as? [String: Any] else {
                print("No updates found for \(place)")
                binding.wrappedValue = 0
                lastUpdatedBinding.wrappedValue = "N/A"
                return
            }

            if let lineLength = update["lineLength"] as? Int,
               let timestamp = update["timestamp"] as? Int {
                DispatchQueue.main.async {
                    binding.wrappedValue = lineLength
                    lastUpdatedBinding.wrappedValue = formatTimestamp(timestamp)
                    print("Updated \(place) with line length: \(lineLength) at \(timestamp)")
                }
            } else {
                print("Invalid data format for \(place)")
                binding.wrappedValue = 0
                lastUpdatedBinding.wrappedValue = "N/A"
            }
        }
    }

    // Format the Unix timestamp into a readable date string
    private func formatTimestamp(_ timestamp: Int) -> String {
        if timestamp == 0 { return "N/A" }
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

struct LineLengthView_Previews: PreviewProvider {
    static var previews: some View {
        LineLengthView(pandaExpressLine: .constant(5), chickFilALine: .constant(3), chucksLine: .constant(7))
    }
}
