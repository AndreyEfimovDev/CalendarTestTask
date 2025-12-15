//
//  MockAPIService.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import Foundation

protocol APIServiceProtocol {
    func fetchWorkouts() async throws -> [Workout]
    func fetchWorkouts(for date: Date) async throws -> [Workout]
    func fetchMetadata(for workoutId: String) async throws -> WorkoutMetadata?
    func fetchDiagramData(for workoutId: String) async throws -> [DiagramData]?
}

