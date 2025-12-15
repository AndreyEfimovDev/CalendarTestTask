//
//  TestDataService.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import Foundation

@MainActor
class TestDataService: APIServiceProtocol {
    private var testWorkouts: [Workout] = []
    
    init() {
        createTestWorkouts()
    }
    
    private func createTestWorkouts() {
        let calendar = Calendar.current
        let now = Date()
        
        testWorkouts = [
            Workout(
                id: "test1",
                workoutActivityType: .walkingRunning,
                workoutStartDate: calendar.date(byAdding: .day, value: -1, to: now) ?? now
            ),
            Workout(
                id: "test2",
                workoutActivityType: .cycling,
                workoutStartDate: calendar.date(byAdding: .day, value: -2, to: now) ?? now
            ),
            Workout(
                id: "test3",
                workoutActivityType: .yoga,
                workoutStartDate: now
            ),
            Workout(
                id: "test4",
                workoutActivityType: .strength,
                workoutStartDate: calendar.date(byAdding: .day, value: -3, to: now) ?? now
            ),
            Workout(
                id: "test5",
                workoutActivityType: .water,
                workoutStartDate: calendar.date(byAdding: .day, value: -5, to: now) ?? now
            )
        ]
    }
    
    // MARK: - APIServiceProtocol
    
    func fetchWorkouts() async throws -> [Workout] {
        // Имитируем задержку сети
        try await Task.sleep(nanoseconds: 500_000_000)
        return testWorkouts
    }
    
    func fetchWorkouts(for date: Date) async throws -> [Workout] {
        try await Task.sleep(nanoseconds: 300_000_000)
        let allWorkouts = try await fetchWorkouts()
        return allWorkouts.filter { workout in
            Calendar.current.isDate(workout.date, inSameDayAs: date)
        }
    }
    
    func fetchMetadata(for workoutId: String) async throws -> WorkoutMetadata? {
        try await Task.sleep(nanoseconds: 400_000_000)
        
        // Тестовые метаданные
        return WorkoutMetadata(
            workoutKey: workoutId,
            workoutActivityType: .walkingRunning,
            workoutStartDate: Date(),
            distance: 5000.0,
            duration: 1800.0,
            maxLayer: 2,
            maxSubLayer: 4,
            avgHumidity: 65.0,
            avgTemp: 20.0,
            comment: "Тестовая тренировка",
            photoBefore: nil,
            photoAfter: nil,
            heartRateGraph: nil,
            activityGraph: nil,
            map: nil
        )
    }
    
    func fetchDiagramData(for workoutId: String) async throws -> [DiagramData]? {
        try await Task.sleep(nanoseconds: 400_000_000)
        
        // Тестовые данные для графика
        var testData: [DiagramData] = []
        for i in 0..<20 {
            testData.append(
                DiagramData(
                    timeNumeric: i,
                    heartRate: 60 + Int.random(in: 0...40),
                    speedKmh: Double.random(in: 0...15),
                    distanceMeters: i * 100,
                    steps: i * 50,
                    elevation: 45.0 + Double.random(in: -5...5),
                    latitude: 55.7558,
                    longitude: 37.6173,
                    temperatureCelsius: 20.0,
                    currentLayer: 0,
                    currentSubLayer: 0,
                    currentTimestamp: Date()
                )
            )
        }
        return testData
    }
}
