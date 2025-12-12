//
//  AppCoordinator.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import SwiftUI
internal import Combine

//enum AppRoute: Hashable {
//    case calendar
//    case dayEvents(Date)
//    case workoutDetail(Workout)
//    case workoutDetailWithId(String)
//}
//

class AppCoordinator: ObservableObject {
    @Published var selectedDate = Date()
    
    let apiService: APIServiceProtocol
    
    // Начальная дата для календаря (ноябрь 2025)
    var initialCalendarDate: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: Date())
        components.year = 2025
        components.month = 11 // Ноябрь
        return calendar.date(from: components) ?? Date()
    }
    
    init(apiService: APIServiceProtocol = MockDataService()) {
        self.apiService = apiService
    }
    
    // Метод для навигации к тренировкам дня
    @ViewBuilder
    func dayEventsView(for date: Date) -> some View {
        DayEventsView(viewModel: DayEventsViewModel(date: date, apiService: apiService))
    }
    
    // Метод для навигации к деталям тренировки
    @ViewBuilder
    func workoutDetailView(for workout: Workout) -> some View {
        WorkoutDetailView(viewModel: WorkoutDetailViewModel(workout: workout, apiService: apiService))
    }
    
    // Метод для навигации к деталям тренировки по ID
    @ViewBuilder
    func workoutDetailView(for workoutId: String) -> some View {
        WorkoutDetailView(viewModel: WorkoutDetailViewModel(workoutId: workoutId, apiService: apiService))
    }
    
    // Создаем корневое представление
    var rootView: some View {
        NavigationStack {
            CalendarContainerView()
                .environmentObject(self)
        }
    }
}

struct CalendarContainerView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        CalendarView(viewModel: CalendarViewModel(
            apiService: coordinator.apiService,
            initialDate: coordinator.initialCalendarDate
        ))
    }
}
