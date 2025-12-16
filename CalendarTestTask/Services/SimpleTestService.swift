//
//  SimpleTestService.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import SwiftUI


class SimpleTestService: APIServiceProtocol {
    
    func fetchWorkouts() async throws -> [Workout] {
        // Тестовые данные
        return [
            Workout(
                id: "test1",
                workoutActivityType: .walkingRunning,
                workoutStartDate: Date()
            ),
            Workout(
                id: "test2",
                workoutActivityType: .yoga,
                workoutStartDate: Date().addingTimeInterval(-86400) // вчера
            )
        ]
    }
    
    func fetchWorkouts(for date: Date) async throws -> [Workout] {
        let workouts = try await fetchWorkouts()
        return workouts.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func fetchMetadata(for workoutId: String) async throws -> WorkoutMetadata? {
        // Тестовые метаданные
        return WorkoutMetadata(
            workoutKey: workoutId,
            workoutActivityType: .walkingRunning,
            workoutStartDate: Date(),
            distance: 5230.5,
            duration: 2700.0,
            maxLayer: 2,
            maxSubLayer: 4,
            avgHumidity: 65.0,
            avgTemp: 12.5,
            comment: "Тестовая тренировка",
            photoBefore: nil,
            photoAfter: nil,
            heartRateGraph: nil,
            activityGraph: nil,
            map: nil
        )
    }
    
    func fetchDiagramData(for workoutId: String) async throws -> [DiagramData]? {
        // Тестовые данные для графика
        var data: [DiagramData] = []
        for i in 0..<10 {
            data.append(DiagramData(
                timeNumeric: i,
                heartRate: 70 + i * 5,
                speedKmh: Double(i) * 1.5,
                distanceMeters: i * 100,
                steps: i * 50,
                elevation: 45.0 + Double(i) * 0.2,
                latitude: 55.7558,
                longitude: 37.6173,
                temperatureCelsius: 12.5,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: Date().addingTimeInterval(TimeInterval(i * 60))
            ))
        }
        return data
    }
}

#Preview("With Simple Test Service") {
    let apiService = SimpleTestService()
    let coordinator = AppCoordinator(apiService: apiService)
    let workout = Workout(
        id: "test1",
        workoutActivityType: .walkingRunning,
        workoutStartDate: Date()
    )
    let viewModel = WorkoutDetailViewModel(
        workout: workout,
        apiService: apiService
    )
    
    return NavigationStack {
        WorkoutDetailView(viewModel: viewModel)
            .environmentObject(coordinator)
    }
}

#Preview("With Mock Data Service") {
    let apiService = MockDataService()
    let coordinator = AppCoordinator(apiService: apiService)
    let workout = Workout(
        id: "7823456789012345",
        workoutActivityType: .walkingRunning,
        workoutStartDate: Date()
    )
    let viewModel = WorkoutDetailViewModel(
        workout: workout,
        apiService: apiService
    )
    
    return NavigationStack {
        WorkoutDetailView(viewModel: viewModel)
            .environmentObject(coordinator)
    }
}


#Preview("Simple Test") {
    let apiService = SimpleTestService()
    let coordinator = AppCoordinator(apiService: apiService)
    let workout = Workout(
        id: "test1",
        workoutActivityType: .walkingRunning,
        workoutStartDate: Date()
    )
    let viewModel = WorkoutDetailViewModel(
        workout: workout,
        apiService: apiService
    )
    
    return NavigationStack {
        WorkoutDetailView(viewModel: viewModel)
            .environmentObject(coordinator)
            .onAppear {
                print("🔄 SimpleTest Preview загружен")
            }
    }
}

#Preview("Real Data") {
    let apiService = MockDataService()
    let coordinator = AppCoordinator(apiService: apiService)
    let workout = Workout(
        id: "7823456789012345",
        workoutActivityType: .walkingRunning,
        workoutStartDate: Date()
    )
    let viewModel = WorkoutDetailViewModel(
        workout: workout,
        apiService: apiService
    )
    
    return NavigationStack {
        WorkoutDetailView(viewModel: viewModel)
            .environmentObject(coordinator)
            .onAppear {
                print("🔄 Real Data Preview загружен")
            }
    }
}
