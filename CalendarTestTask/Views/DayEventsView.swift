//
//   DayWorkoutsSection.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 15.12.2025.
//

import SwiftUI

struct DayEventsView: View {
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
            HStack {
                Text(Calendar.current.isDateInToday(date) ? "Тренировки сегодня" : "Тренировки на \(dateFormatter.string(from: date))")
                    .font(.headline)
                    .foregroundColor(Color.mycolor.myAccent)

                Spacer()
            }
            .padding(.horizontal)
            
            if workouts.isEmpty {
                Text(Calendar.current.isDateInToday(date) ? "Сегодня нет тренировок" : "На выбранный день нет тренировок")
                    .foregroundColor(Color.mycolor.myAccent)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(workouts) { workout in
                    NavigationLink {
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

#Preview("25 ноября - 2 тренировки") {
    let coordinator = AppCoordinator(apiService: MockDataService())
    
    var dateComponents = DateComponents()
    dateComponents.year = 2025
    dateComponents.month = 11
    dateComponents.day = 25
    let date = Calendar.current.date(from: dateComponents)!
    
    let workouts = [
        Workout(
            id: "7823456789012345",
            workoutActivityType: .walkingRunning,
            workoutStartDate: createDate(year: 2025, month: 11, day: 25, hour: 9, minute: 30)
        ),
        Workout(
            id: "7823456789012346",
            workoutActivityType: .yoga,
            workoutStartDate: createDate(year: 2025, month: 11, day: 25, hour: 18, minute: 0)
        )
    ]
    
    return NavigationStack {
        DayEventsView(date: date, workouts: workouts)
            .environmentObject(coordinator)
    }
}

#Preview("24 ноября - 2 тренировки") {
    let coordinator = AppCoordinator(apiService: MockDataService())
    
    var dateComponents = DateComponents()
    dateComponents.year = 2025
    dateComponents.month = 11
    dateComponents.day = 24
    let date = Calendar.current.date(from: dateComponents)!
    
    let workouts = [
        Workout(
            id: "7823456789012347",
            workoutActivityType: .water,
            workoutStartDate: createDate(year: 2025, month: 11, day: 24, hour: 7, minute: 15)
        ),
        Workout(
            id: "7823456789012348",
            workoutActivityType: .walkingRunning,
            workoutStartDate: createDate(year: 2025, month: 11, day: 24, hour: 17, minute: 45)
        )
    ]
    
    return NavigationStack {
        DayEventsView(date: date, workouts: workouts)
            .environmentObject(coordinator)
    }
}

#Preview("23 ноября - 1 тренировка") {
    let coordinator = AppCoordinator(apiService: MockDataService())
    
    var dateComponents = DateComponents()
    dateComponents.year = 2025
    dateComponents.month = 11
    dateComponents.day = 23
    let date = Calendar.current.date(from: dateComponents)!
    
    let workouts = [
        Workout(
            id: "7823456789012349",
            workoutActivityType: .cycling,
            workoutStartDate: createDate(year: 2025, month: 11, day: 23, hour: 10, minute: 0)
        )
    ]
    
    return NavigationStack {
        DayEventsView(date: date, workouts: workouts)
            .environmentObject(coordinator)
    }
}

#Preview("Пустое состояние") {
    let coordinator = AppCoordinator(apiService: MockDataService())
    
    var dateComponents = DateComponents()
    dateComponents.year = 2025
    dateComponents.month = 11
    dateComponents.day = 20
    let date = Calendar.current.date(from: dateComponents)!
    
    return NavigationStack {
        DayEventsView(date: date, workouts: [])
            .environmentObject(coordinator)
    }
}

#Preview("Сегодня - без тренировок") {
    let coordinator = AppCoordinator(apiService: MockDataService())
    
    return NavigationStack {
        DayEventsView(date: Date(), workouts: [])
            .environmentObject(coordinator)
    }
}

#Preview("Сегодня - с тренировками") {
    let coordinator = AppCoordinator(apiService: MockDataService())
    
    let workouts = [
        Workout(
            id: "today1",
            workoutActivityType: .walkingRunning,
            workoutStartDate: Date().addingTimeInterval(-3600) // 1 час назад
        ),
        Workout(
            id: "today2",
            workoutActivityType: .yoga,
            workoutStartDate: Date().addingTimeInterval(7200) // через 2 часа
        )
    ]
    
    return NavigationStack {
        DayEventsView(date: Date(), workouts: workouts)
            .environmentObject(coordinator)
    }
}

// MARK: - Helper Function

private func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    return Calendar.current.date(from: components) ?? Date()
}
