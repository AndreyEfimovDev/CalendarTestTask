//
//   DayWorkoutsSection.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 15.12.2025.
//

import SwiftUI

struct DayWorkoutsSection: View {
    let date: Date
    let workouts: [Workout]
    
    @EnvironmentObject  var coordinator: AppCoordinator
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Заголовок с датой
            HStack {
                Text(Calendar.current.isDateInToday(date) ? "Тренировки сегодня" : "Тренировки на \(dateFormatter.string(from: date))")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            
            // Список тренировок или заглушка
            if workouts.isEmpty {
                Text(Calendar.current.isDateInToday(date) ? "Сегодня нет тренировок" : "На выбранный день нет тренировок")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(workouts) { workout in
                    NavigationLink {
                        // ✅ ПРАВИЛЬНО: используем существующий метод
                        coordinator.workoutDetailView(for: workout.id)
                    } label: {
                        WorkoutCard(workout: workout)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal)
                }
            }
        }
        .padding(.vertical)
    }
    
}


#Preview {
    let workouts = [
        Workout(
            id: UUID().uuidString,
            workoutActivityType: WorkoutActivityType(rawValue: "Силовая") ?? .walkingRunning,
            workoutStartDate: Date()
        ),
        Workout(
            id: UUID().uuidString,
            workoutActivityType: WorkoutActivityType(rawValue: "Бег") ?? .walkingRunning,
            workoutStartDate: Date()
        )
    ]
    let mockCoordinator = AppCoordinator(apiService: MockDataService())
    
    // Оборачиваем в NavigationStack и добавляем environmentObject
      NavigationStack {
          DayWorkoutsSection(
              date: Date(),
              workouts: workouts
          )
          .environmentObject(mockCoordinator) // ✅ Добавляем координатор
      }
      .padding()
}

#Preview("Пустой") {
    
    
    let mockCoordinator = AppCoordinator(apiService: MockDataService())
    
    NavigationStack {
            DayWorkoutsSection(
                date: Date(),
                workouts: []
            )
            .environmentObject(mockCoordinator) // ✅ Добавляем координатор
        }
        .padding()
}

