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
                print("✅ Данные загружены: \(workouts.count) тренировок")
                
                // Перерисовка
                DispatchQueue.main.async {
                    self.objectWillChange.send()
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
    
    func isNovember2025() -> Bool {
        let year = Calendar.current.component(.year, from: currentDate)
        let month = Calendar.current.component(.month, from: currentDate)
        return year == 2025 && month == 11
    }

    
//    func workoutsForDay(_ date: Date) -> [Workout] {
//        workouts.filter { workout in
//            Calendar.current.isDate(workout.date, inSameDayAs: date)
//        }
//    }
    
//    func workoutsForDay(_ date: Date) -> [Workout] {
//        let filteredWorkouts = workouts.filter { workout in
//            Calendar.current.isDate(workout.date, inSameDayAs: date)
//        }
//        
//        // ОТЛАДКА для дней 21-25 ноября
//        let day = Calendar.current.component(.day, from: date)
//        let month = Calendar.current.component(.month, from: date)
//        if month == 11 && (21...25).contains(day) {
//            print("🔍 workoutsForDay(\(day).11.2025): \(filteredWorkouts.count) тренировок")
//            for workout in filteredWorkouts {
//                print("   - \(workout.workoutActivityType.rawValue) в \(workout.timeString)")
//            }
//        }
//        
//        return filteredWorkouts
//    }
    
    func workoutsForDay(_ date: Date) -> [Workout] {
        // ОТЛАДКА
        let day = Calendar.current.component(.day, from: date)
        let month = Calendar.current.component(.month, from: date)
        let year = Calendar.current.component(.year, from: date)
        
        let filteredWorkouts = workouts.filter { workout in
            Calendar.current.isDate(workout.date, inSameDayAs: date)
        }
        
        // Отладка для всех дней 21-25
        if (21...25).contains(day) {
            print("📅 \(day).\(month).\(year): \(filteredWorkouts.count) тренировок")
            if filteredWorkouts.count > 0 {
                print("   Типы: \(filteredWorkouts.map { $0.workoutActivityType.rawValue })")
            }
        }
        
        return filteredWorkouts
    }

    
    func hasWorkoutsOnDay(_ date: Date) -> Bool {
        let workoutsForDay = workoutsForDay(date)
        let result = !workoutsForDay.isEmpty
        
        // КРИТИЧЕСКАЯ ОТЛАДКА
        let day = Calendar.current.component(.day, from: date)
        let month = Calendar.current.component(.month, from: date)
        let year = Calendar.current.component(.year, from: date)
        
        if month == 11 && year == 2025 && (21...25).contains(day) {
            print("🔍 [REAL] hasWorkoutsOnDay(\(day).\(month).\(year)) = \(result)")
            print("   workouts.count = \(workouts.count)")
            print("   workoutsForDay.count = \(workoutsForDay.count)")
            
            if workoutsForDay.count > 0 {
                for workout in workoutsForDay {
                    print("   - \(workout.workoutActivityType.rawValue) в \(workout.timeString)")
                }
            }
        }
        
        return result
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

