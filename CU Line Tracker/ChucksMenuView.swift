//
//  ChucksMenuView.swift
//  CU Line Tracker
//
//  Created by Asher Antrim on 8/24/24.
//

import SwiftUI
import WebKit
import FirebaseAuth


// Define custom colors for Gold and Blue
let goldColor = Color(red: 231/255, green: 164/255, blue: 60/255) // Gold
let blueColor = Color(red: 23/255, green: 37/255, blue: 54/255) // Blue
let whiteColor = Color.white


struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct ChucksMenuView: View {
    let url = URL(string: "https://www.cedarville.edu/offices/dining-hall")!

    var body: some View {
        WebView(url: url)
            .background(goldColor.edgesIgnoringSafeArea(.all))
    }
}

struct ChucksMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ChucksMenuView()
    }
}
