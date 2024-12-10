import SwiftUI

struct LineLengthView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Current Line Lengths")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                    .foregroundColor(AppColors.blue)
                
                ScrollView {
                    VStack(spacing: 15) {
                        lineDisplayView(place: "Panda Express",
                                        lineLength: viewModel.pandaExpressLine,
                                        lastUpdated: viewModel.lastUpdatedPandaExpress)
                        
                        lineDisplayView(place: "Chick-fil-A",
                                        lineLength: viewModel.chickFilALine,
                                        lastUpdated: viewModel.lastUpdatedChickFilA)
                        
                        lineDisplayView(place: "Chuck's",
                                        lineLength: viewModel.chucksLine,
                                        lastUpdated: viewModel.lastUpdatedChucks)
                        
                        lineDisplayView(place: "The Café",
                                        lineLength: viewModel.cafeLine,
                                        lastUpdated: viewModel.lastUpdatedCafe)
                    }
                    .padding()
                    .background(AppColors.gold)
                    .cornerRadius(12)
                }
                .refreshable {
                    viewModel.fetchAllLineLengths()
                }
            }
            .background(AppColors.gold.edgesIgnoringSafeArea(.all))
        }
    }
    
    private func lineDisplayView(place: String, lineLength: Int, lastUpdated: String) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(place):")
                    .font(.headline)
                    .foregroundColor(AppColors.blue)
                Spacer()
                Text("\(lineLength)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.blue)
            }
            Text("Last updated: \(lastUpdated)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
    }
}
