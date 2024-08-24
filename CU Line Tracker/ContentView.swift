import SwiftUI

struct ContentView: View {
    @State private var pandaExpressLine: Int = 0
    @State private var chickFilALine: Int = 0
    @State private var chucksLine: Int = 0

    var body: some View {
        TabView {
            LineLengthView(pandaExpressLine: $pandaExpressLine, chickFilALine: $chickFilALine, chucksLine: $chucksLine)
                .tabItem {
                    Image(systemName: "list.number")
                    Text("View Lines")
                }
            
            InputLengthView(pandaExpressLine: $pandaExpressLine, chickFilALine: $chickFilALine, chucksLine: $chucksLine)
                .tabItem {
                    Image(systemName: "pencil")
                    Text("Update Length")
                }
            ChucksMenuView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Chuck's Menu")
                }
        }
    }
}

#Preview {
    ContentView()
}
