import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

struct ChucksMenuView: View {
    let url = URL(string: "https://www.cedarville.edu/offices/dining-hall")!
    var body: some View {
        WebView(url: url)
            .background(AppColors.gold.edgesIgnoringSafeArea(.all))
            .navigationTitle("Chuck's Menu")
    }
}
