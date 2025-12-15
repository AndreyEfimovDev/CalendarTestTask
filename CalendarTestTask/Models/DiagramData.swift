//
//  DiagramData.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

// WorkoutCalendar/Models/DiagramData.swift
import Foundation

struct DiagramData: Codable, Identifiable {
    var id: Int { timeNumeric }
    
    let timeNumeric: Int
    let heartRate: Int
    let speedKmh: Double
    let distanceMeters: Int
    let steps: Int
    let elevation: Double
    let latitude: Double
    let longitude: Double
    let temperatureCelsius: Double
    let currentLayer: Int
    let currentSubLayer: Int
    let currentTimestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case timeNumeric = "time_numeric"
        case heartRate
        case speedKmh = "speed_kmh"
        case distanceMeters
        case steps
        case elevation
        case latitude
        case longitude
        case temperatureCelsius
        case currentLayer
        case currentSubLayer
        case currentTimestamp
    }
}
