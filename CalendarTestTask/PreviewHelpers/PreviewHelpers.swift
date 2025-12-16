//
//  PreviewHelpers.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import SwiftUI

struct PreviewWrapper<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        let apiService = MockDataService()
        let coordinator = AppCoordinator(apiService: apiService)
        
        return NavigationStack {
            content()
                .environmentObject(coordinator)
        }
    }
}

#Preview("Calendar View") {
    PreviewWrapper {
        let apiService = MockDataService()
        let coordinator = AppCoordinator(apiService: apiService)
        let viewModel = CalendarViewModel(
            apiService: apiService,
            initialDate: coordinator.initialCalendarDate
        )
        
        return CalendarView(viewModel: viewModel)
    }
}
//
//#Preview("Day Events View") {
//    PreviewWrapper {
//        let apiService = MockDataService()
//        let viewModel = DayEventsViewModel(
//            date: Date(),
//            apiService: apiService
//        )
//        
//        return DayEventsView(viewModel: viewModel)
//    }
//}
