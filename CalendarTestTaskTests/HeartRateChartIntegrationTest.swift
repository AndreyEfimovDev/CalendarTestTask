//
//  HeartRateChartIntegrationTest.swift
//  CalendarTestTaskTests
//
//  Created by Andrey Efimov on 12.12.2025.
//

import XCTest
@testable import CalendarTestTask
import SwiftUI

@MainActor
class HeartRateChartIntegrationTest: XCTestCase {
    
    func testHeartRateChartInWorkoutDetail() async throws {
        // Given
        let service = MockDataService()
        let workout = Workout(
            id: "7823456789012345",
            workoutActivityType: .walkingRunning,
            workoutStartDate: Date()
        )
        let viewModel = WorkoutDetailViewModel(workout: workout, apiService: service)
        
        // When
        viewModel.loadData()
        
        // Ждем загрузки
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 секунда
        
        // Then
        XCTAssertNotNil(viewModel.workout)
        XCTAssertNotNil(viewModel.metadata)
        XCTAssertNotNil(viewModel.diagramData)
        XCTAssertGreaterThan(viewModel.diagramData?.count ?? 0, 0)
    }
    
    func testHeartRateChartViewCreation() {
        // Given
        let testData = createTestDiagramData()
        
        // When
        let chartView = HeartRateChartView(diagramData: testData)
        
        // Then - проверяем что view создается
        XCTAssertNotNil(chartView)
        
        // Можно проверить через UIHostingController
        let hostingController = UIHostingController(rootView: chartView)
        XCTAssertNotNil(hostingController.view)
    }
    
    private func createTestDiagramData() -> [DiagramData] {
        var data: [DiagramData] = []
        for i in 0..<10 {
            data.append(DiagramData(
                timeNumeric: i,
                heartRate: 70 + i * 3,
                speedKmh: Double(i) * 1.5,
                distanceMeters: i * 100,
                steps: i * 80,
                elevation: 45.0,
                latitude: 55.7558,
                longitude: 37.6173,
                temperatureCelsius: 20.0,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: Date()
            ))
        }
        return data
    }
}
