//
//  CalendarTestTaskApp.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import SwiftUI

@main
struct WorkoutCalendarApp: App {
    

//    @StateObject private var coordinator = AppCoordinator(apiService: TestDataService())
    
    @StateObject private var coordinator = AppCoordinator(apiService: MockDataService())
    
    var body: some Scene {
        WindowGroup {
            coordinator.rootView
                .environmentObject(coordinator)
                .preferredColorScheme(coordinator.selectedTheme.colorScheme)
                .onAppear {
                    print("🚀 Приложение запущено")
                }
        }
    }
}



