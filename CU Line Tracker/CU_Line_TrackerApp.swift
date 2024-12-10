//
//  CU_Line_TrackerApp.swift
//  CU Line Tracker
//
//  Created by Asher Antrim on 8/23/24.
//

import SwiftUI
import FirebaseCore

@main
struct CU_Line_TrackerApp: App {
    @StateObject var viewModel = AppViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
