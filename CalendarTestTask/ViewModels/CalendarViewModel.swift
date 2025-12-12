//
//  CalendarViewModel.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import Foundation
import SwiftUI
internal import Combine

class CalendarViewModel: ObservableObject {
    @Published var currentDate: Date
    @Published var workouts: [Workout] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedDate = Date()
    @Published var showingDayEvents = false
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol, initialDate: Date? = nil) {
        self.apiService = apiService
        
        // Устанавливаем начальную дату
        if let initialDate = initialDate {
            self.currentDate = initialDate
        } else {
            // По умолчанию - текущий месяц
            self.currentDate = Date()
        }
        
        loadWorkouts()
    }

    func loadWorkouts() {
        Task { @MainActor in
            isLoading = true
            errorMessage = nil
            
            do {
                workouts = try await apiService.fetchWorkouts()
                print("✅ Загружено тренировок: \(workouts.count)")
                print("📅 Даты тренировок:")
                for workout in workouts {
                    print("  - \(workout.workoutStartDate): \(workout.workoutActivityType.rawValue)")
                }
            } catch let apiError as APIError {
                errorMessage = apiError.description
                print("❌ API Error: \(apiError.description)")
            } catch let decodingError as DecodingError {
                errorMessage = "Ошибка формата данных"
                print("❌ Decoding Error: \(decodingError)")
            } catch {
                errorMessage = "Неизвестная ошибка: \(error.localizedDescription)"
                print("❌ Unknown Error: \(error)")
            }
            
            isLoading = false
        }
    }
    
    // MARK: - Calendar Data
    var currentMonthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: currentDate).capitalized
    }
    
    func workoutsForDay(_ date: Date) -> [Workout] {
        workouts.filter { workout in
            Calendar.current.isDate(workout.date, inSameDayAs: date)
        }
    }
    
    func hasWorkoutsOnDay(_ date: Date) -> Bool {
        !workoutsForDay(date).isEmpty
    }
    
    func workoutTypesForDay(_ date: Date) -> [WorkoutActivityType] {
        Array(Set(workoutsForDay(date).map { $0.workoutActivityType }))
    }
    
    // MARK: - Month Navigation
    func goToPreviousMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) {
            currentDate = newDate
        }
    }
    
    func goToNextMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) {
            currentDate = newDate
        }
    }
    
    func goToToday() {
        currentDate = Date()
    }
    
    // MARK: - Calendar Generation
    func datesInMonth() -> [Date] {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: currentDate)
        let year = calendar.component(.year, from: currentDate)
        
        guard let monthDate = calendar.date(from: DateComponents(year: year, month: month)) else {
            return []
        }
        
        guard let range = calendar.range(of: .day, in: .month, for: monthDate) else {
            return []
        }
        
        return range.compactMap { day -> Date? in
            calendar.date(from: DateComponents(year: year, month: month, day: day))
        }
    }
    
    func firstDayOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        return calendar.date(from: components) ?? currentDate
    }
    
    func weekdayOffset() -> Int {
        let calendar = Calendar.current
        let firstDay = firstDayOfMonth()
        let weekday = calendar.component(.weekday, from: firstDay)
        // Adjust for Monday as first day (1 = Monday, 7 = Sunday)
        return (weekday + 5) % 7
    }
    
    func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
    
    func isCurrentMonth(_ date: Date) -> Bool {
        Calendar.current.isDate(date, equalTo: currentDate, toGranularity: .month)
    }
    
    // MARK: - Selection
    func selectDay(_ date: Date) {
        selectedDate = date
        showingDayEvents = true
        print("Выбран день: \(date)")
    }

}

