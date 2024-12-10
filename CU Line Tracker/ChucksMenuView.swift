import SwiftUI
import WebKit
import SwiftSoup

// WebView to load dynamic HTML content
struct WebView: UIViewRepresentable {
    @Binding var htmlContent: String
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if !htmlContent.isEmpty {
            // Load the extracted HTML content
            uiView.loadHTMLString(htmlContent, baseURL: nil)
        }
    }
}

// Main View for Chuck's Menu
struct ChucksMenuView: View {
    @State private var htmlContent: String = ""
    let url = "https://www.cedarville.edu/offices/dining-hall"
    
    var body: some View {
        WebView(htmlContent: $htmlContent)
            .background(AppColors.gold.edgesIgnoringSafeArea(.all))
            .navigationTitle("Chuck's Menu")
            .onAppear {
                fetchMenuContent(from: url) { content in
                    if let content = content {
                        DispatchQueue.main.async {
                            self.htmlContent = content
                        }
                    }
                }
            }
    }
    
    // Function to fetch and extract the specific HTML content
    func fetchMenuContent(from urlString: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            if let html = String(data: data, encoding: .utf8) {
                do {
                    // Parse the HTML and extract the specific table body
                    let document = try SwiftSoup.parse(html)
                    let tableContent = try document.select("body > main > div:nth-of-type(2) > div > div:nth-of-type(2) > div:nth-of-type(3) > table > tbody").html()
                    completion(tableContent)
                } catch {
                    print("Error parsing HTML: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
}
