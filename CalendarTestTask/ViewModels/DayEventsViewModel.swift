//
//  DayEventsViewModel.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import Foundation
internal import Combine

class DayEventsViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let date: Date
    private let apiService: APIServiceProtocol
    
    init(date: Date, apiService: APIServiceProtocol) {
        self.date = date
        self.apiService = apiService
        loadWorkouts()
    }
    
    func loadWorkouts() {
        Task { @MainActor in
            isLoading = true
            errorMessage = nil
            
            do {
                workouts = try await apiService.fetchWorkouts(for: date) // Не блокируем главный поток во время ожидания, освобождается для других задач UI
                print("📅 DayEventsView загружено тренировок для \(formattedDate): \(workouts.count)")
                for workout in workouts {
                    print("   - \(workout.timeString): \(workout.workoutActivityType.localizedName)")
                }
            } catch let apiError as APIError {
                errorMessage = apiError.description
                print("❌ Ошибка в DayEventsView: \(apiError.description)")
            } catch {
                errorMessage = "Ошибка загрузки"
                print("❌ Неизвестная ошибка в DayEventsView: \(error)")
            }
            
            isLoading = false
        }
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
    
    var hasWorkouts: Bool {
        !workouts.isEmpty
    }
}
