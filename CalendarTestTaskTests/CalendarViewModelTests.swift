//
//  CalendarViewModelTests.swift
//  CalendarTestTaskTests
//
//  Created by Andrey Efimov on 12.12.2025.
//

import XCTest
@testable import CalendarTestTask

@MainActor
class CalendarViewModelTests: XCTestCase {
    
    func testWorkoutsFilteringByDate() async {
            // Given
            let service = TestDataService()
            let viewModel = CalendarViewModel(apiService: service)
            
            // Ждем загрузки данных
            try? await Task.sleep(nanoseconds: 200_000_000)
            
            // When
            let today = Date()
            let workouts = viewModel.workoutsForDay(today)
            
            // Then
            XCTAssertEqual(workouts.count, 1) // Только одна тренировка сегодня
            XCTAssertEqual(workouts.first?.workoutActivityType, .yoga)
        }
        
        func testHasWorkoutsOnDay() async {
            // Given
            let service = TestDataService()
            let viewModel = CalendarViewModel(apiService: service)
            
            // Ждем загрузки
            try? await Task.sleep(nanoseconds: 200_000_000)
            
            // When & Then
            let today = Date()
            XCTAssertTrue(viewModel.hasWorkoutsOnDay(today))
            
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
            XCTAssertTrue(viewModel.hasWorkoutsOnDay(yesterday))
            
            let futureDate = Calendar.current.date(byAdding: .day, value: 10, to: today)!
            XCTAssertFalse(viewModel.hasWorkoutsOnDay(futureDate))
        }
        
        func testMonthNavigation() {
            // Этот тест не требует async, так как не использует сервис напрямую
            // Given
            let service = TestDataService()
            let viewModel = CalendarViewModel(apiService: service)
            let initialMonth = viewModel.currentDate
            
            // When
            viewModel.goToNextMonth()
            
            // Then
            let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: initialMonth)
            let calendar = Calendar.current
            XCTAssertEqual(calendar.component(.month, from: viewModel.currentDate),
                          calendar.component(.month, from: nextMonth!))
        }
        
        func testCurrentMonthYearFormat() {
            // Given
            let service = TestDataService()
            let viewModel = CalendarViewModel(apiService: service)
            
            // When
            let monthYear = viewModel.currentMonthYear
            
            // Then - проверяем формат
            XCTAssertFalse(monthYear.isEmpty)
            XCTAssertTrue(monthYear.contains("202")) // Должен содержать год
        }
}
