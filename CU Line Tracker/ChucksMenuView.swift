import Foundation
import SwiftUI

struct MenuResponse: Codable {
    let entrydateformatted: String
    let entrydate: String
    let meals: [Meal]
    let entrydatedayofweek: String
}

struct Meal: Codable {
    let entryid: Int
    let othercomments: String?
    let mealtime: String
    let menudescription: [String]
    let specialslist: [String]?
    let specials: String
    
    enum CodingKeys: String, CodingKey {
        case entryid, othercomments, mealtime, menudescription, specialslist, specials
    }
}

private func fetchMenu(completion: @escaping ([MenuResponse]?) -> Void) {
    let urlString = "https://www.cedarville.edu/cf/dininghall/ws.cfm?SelectedNumDays=7&format=json3"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error fetching menu: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("Invalid HTTP response")
            completion(nil)
            return
        }
        
        guard let data = data else {
            print("No data received")
            completion(nil)
            return
        }
        
        // Print raw JSON response for debugging
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON response: \(jsonString)")
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase // Handle snake_case to camelCase if needed
            let menu = try decoder.decode([MenuResponse].self, from: data)
            print("Successfully decoded JSON: \(menu)")
            completion(menu)
        } catch let DecodingError.dataCorrupted(context) {
            print("Data corrupted: \(context.debugDescription)")
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found: \(context.debugDescription)")
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch: \(context.debugDescription)")
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found: \(context.debugDescription)")
        } catch {
            print("Unknown error: \(error.localizedDescription)")
        }
        
    }.resume()
}

struct MealRow: View {
    let meal: Meal

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(meal.mealtime)
                .font(.headline)
                .foregroundColor(AppColors.white)
            Text(meal.menudescription.joined(separator: ", "))
                .font(.body)
                .foregroundColor(AppColors.gold)
            if let specials = meal.specialslist, !specials.isEmpty {
                Text("Specials: \(specials.joined(separator: ", "))")
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(AppColors.white.opacity(0.8))
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(AppColors.blue.opacity(0.9)))
        .padding(.horizontal)
    }
}

struct MenuView: View {
    @State private var menu: [MenuResponse] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading menu...")
                        .progressViewStyle(CircularProgressViewStyle(tint: AppColors.gold))
                } else if menu.isEmpty {
                    Text("No menu available.")
                        .font(.headline)
                        .foregroundColor(AppColors.gold)
                } else {
                    List {
                        ForEach(menu, id: \.entrydateformatted) { day in
                            Section(header: sectionHeader(day: day)) {
                                ForEach(day.meals, id: \.entryid) { meal in
                                    MealRow(meal: meal)
                                }
                            }
                            .listRowBackground(AppColors.blue)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .background(AppColors.blue.edgesIgnoringSafeArea(.all))
            .onAppear {
                fetchMenu { menuResponse in
                    DispatchQueue.main.async {
                        self.menu = menuResponse ?? []
                        self.isLoading = false
                    }
                }
            }
            .navigationTitle("Chuck's Menu")
        }
    }

    private func sectionHeader(day: MenuResponse) -> some View {
        Text("\(day.entrydatedayofweek), \(day.entrydateformatted)")
            .font(.headline)
            .foregroundColor(AppColors.white)
            .padding()
            .background(AppColors.gold.opacity(0.8))
            .cornerRadius(8)
    }
}
