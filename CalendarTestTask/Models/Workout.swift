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
    
    // Computed properties
    var date: Date {
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
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        lhs.id == rhs.id
    }
}

enum WorkoutActivityType: String, Codable, CaseIterable {
    case walkingRunning = "Walking/Running"
    case yoga = "Yoga"
    case water = "Water"
    case cycling = "Cycling"
    case strength = "Strength"
    
    var icon: String {
        switch self {
        case .walkingRunning: return "figure.walk"
        case .yoga: return "figure.mind.and.body"
        case .water: return "drop.fill"
        case .cycling: return "bicycle"
        case .strength: return "dumbbell.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .walkingRunning: return .blue
        case .yoga: return .purple
        case .water: return .cyan
        case .cycling: return .green
        case .strength: return .orange
        }
    }
    
    var localizedName: String {
        switch self {
        case .walkingRunning: return "Ходьба/Бег"
        case .yoga: return "Йога"
        case .water: return "Водные процедуры"
        case .cycling: return "Велоспорт"
        case .strength: return "Силовая"
        }
    }
}
