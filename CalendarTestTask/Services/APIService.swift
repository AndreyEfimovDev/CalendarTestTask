//
//  MockAPIService.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

// WorkoutCalendar/Services/APIService.swift
import Foundation

protocol APIServiceProtocol {
    func fetchWorkouts() async throws -> [Workout]
    func fetchWorkouts(for date: Date) async throws -> [Workout]
    func fetchMetadata(for workoutId: String) async throws -> WorkoutMetadata?
    func fetchDiagramData(for workoutId: String) async throws -> [DiagramData]?
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
