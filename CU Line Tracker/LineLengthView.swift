import SwiftUI

struct LineLengthView: View {
    @Binding var pandaExpressLine: Int
    @Binding var chickFilALine: Int
    @Binding var chucksLine: Int

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Current Line Lengths")
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(Color("CedarvilleBlue"))

                VStack(spacing: 15) {
                    lineDisplayView(place: "Panda Express", lineLength: pandaExpressLine)
                    lineDisplayView(place: "Chick-fil-A", lineLength: chickFilALine)
                    lineDisplayView(place: "Chuck's", lineLength: chucksLine)
                }
                .padding()
                
                Spacer()
            }
            .background(Color("CedarvilleGold").edgesIgnoringSafeArea(.all))
            .navigationTitle("Current Lengths")
        }
    }

    private func lineDisplayView(place: String, lineLength: Int) -> some View {
        HStack {
            Text("\(place):")
                .font(.headline)
                .foregroundColor(Color("CedarvilleBlue"))
            Spacer()
            Text("\(lineLength)")
                .font(.title)
                .foregroundColor(Color("CedarvilleBlue"))
        }
        .padding()
    }
}

struct LineLengthView_Previews: PreviewProvider {
    static var previews: some View {
        LineLengthView(pandaExpressLine: .constant(5), chickFilALine: .constant(3), chucksLine: .constant(7))
    }
}

