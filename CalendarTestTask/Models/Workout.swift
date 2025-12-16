//
//  Workout.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import SwiftUI

struct Workout: Identifiable, Codable, Hashable {
    let id: String
    let workoutActivityType: WorkoutActivityType
    let workoutStartDate: Date
    
    var date: Date { // возвращаем дату без времени (начало дня)
        Calendar.current.startOfDay(for: workoutStartDate)
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: workoutStartDate)
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: workoutStartDate)
    }
}
