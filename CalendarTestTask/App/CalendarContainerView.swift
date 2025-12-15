//
//  CalendarContainerView.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 15.12.2025.
//

import SwiftUI

struct CalendarContainerView: View {
    
    @EnvironmentObject private var coordinator: AppCoordinator
    
    @State private var showLaunchView: Bool = true
    
    var body: some View {
        
        ZStack{
            if showLaunchView {
                LaunchView() {
                    showLaunchView = false
                }
                .transition(.move(edge: .leading))
            } else {
                CalendarView(viewModel: CalendarViewModel(
                    apiService: coordinator.apiService,
                    initialDate: coordinator.initialCalendarDate,
                    coordinator: coordinator
                ))
            }
        }
        .environmentObject(AppCoordinator())
    }
}
