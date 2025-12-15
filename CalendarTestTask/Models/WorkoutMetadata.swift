//
//  WorkoutMetadata.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import Foundation

struct WorkoutMetadata: Codable {
    let workoutKey: String
    let workoutActivityType: WorkoutActivityType
    let workoutStartDate: Date
    
    @DoubleOrString var distance: Double
    @DoubleOrString var duration: Double
    
    let maxLayer: Int
    let maxSubLayer: Int
    
    @DoubleOrString var avgHumidity: Double
    @DoubleOrString var avgTemp: Double
    
    let comment: String?
    let photoBefore: String?
    let photoAfter: String?
    let heartRateGraph: String?
    let activityGraph: String?
    let map: String?
    
    enum CodingKeys: String, CodingKey {
        case workoutKey, workoutActivityType, workoutStartDate
        case distance, duration, maxLayer, maxSubLayer
        case avgHumidity = "avg_humidity"
        case avgTemp = "avg_temp"
        case comment, photoBefore, photoAfter
        case heartRateGraph, activityGraph, map
    }
    
    var formattedDistance: String {
        if distance >= 1000 {
            return String(format: "%.1f км", distance / 1000)
        } else if distance > 0 {
            return String(format: "%.0f м", distance)
        } else {
            return "—"
        }
    }
    
    var formattedDuration: String {
        let totalSeconds = Int(duration)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        
        if hours > 0 {
            return "\(hours)ч \(minutes)мин"
        } else {
            return "\(minutes) мин"
        }
    }
    
    var formattedTemperature: String {
        return String(format: "%.1f°C", avgTemp)
    }
    
    var formattedHumidity: String {
        return String(format: "%.0f%%", avgHumidity)
    }
}
