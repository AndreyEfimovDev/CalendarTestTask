//
//  Enums.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 15.12.2025.
//

import SwiftUI


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


enum APIError: Error {
    case fileNotFound
    case decodingError
    case invalidData
    case networkError
    
    var description: String {
        switch self {
        case .fileNotFound:
            return "Файл данных не найден"
        case .decodingError:
            return "Ошибка обработки данных"
        case .invalidData:
            return "Некорректные данные"
        case .networkError:
            return "Ошибка сети"
        }
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
        case .walkingRunning: return Color.mycolor.myYellow
        case .yoga: return Color.mycolor.myPurple
        case .water: return Color.mycolor.myBlue
        case .cycling: return Color.mycolor.myGreen
        case .strength: return Color.mycolor.myOrange
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
