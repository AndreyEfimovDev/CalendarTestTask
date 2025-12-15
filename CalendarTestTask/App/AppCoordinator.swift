//
//  AppCoordinator.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import SwiftUI
internal import Combine


enum Theme: String, CaseIterable, Codable {
    case light
    case dark
    case system

    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "System"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}


class AppCoordinator: ObservableObject {
    
    @Published var selectedDate: Date?
    
    @AppStorage("selectedTheme") var selectedTheme: Theme = .system
    
    let apiService: APIServiceProtocol
    
    // Начальная дата для календаря (ноябрь 2025)
    var initialCalendarDate: Date {
        
//        // Устанавливает текущую дату в ноябрь 2025
//        let calendar = Calendar.current
//        var components = calendar.dateComponents([.year, .month], from: Date())
//        components.year = 2025
//        components.month = 11 // Ноябрь
//        return calendar.date(from: components) ?? Date()
        
        // Текущая дата
        return Date()

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
    
    func setSelectedDate(_ date: Date?) {
        selectedDate = date
    }
    
    var displayDate: Date {
        return selectedDate ?? initialCalendarDate
    }
    
}

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
