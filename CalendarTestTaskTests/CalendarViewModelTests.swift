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
    
    
    private func dateFromString(_ string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: string)!
    }
    
    func testWorkoutsFilteringByDate() {
        // Given
        let viewModel = CalendarViewModel(apiService: MockAPIService())
        
        // Создаем тестовые данные НАПРЯМУЮ
        let testWorkouts = [
            Workout(
                id: "1",
                workoutActivityType: .walkingRunning,
                workoutStartDate: dateFromString("2025-11-25 09:30:00")
            ),
            Workout(
                id: "2",
                workoutActivityType: .yoga,
                workoutStartDate: dateFromString("2025-11-25 15:45:00")
            ),
            Workout(
                id: "3",
                workoutActivityType: .cycling,
                workoutStartDate: dateFromString("2025-11-26 10:00:00")
            )
        ]
        
        // Устанавливаем данные НАПРЯМУЮ, без loadWorkouts()
        viewModel.setTestWorkouts(testWorkouts)
        
        // Когда: НИКАКОГО wait(), НИКАКОГО ожидания
        let testDate = dateFromString("2025-11-25 00:00:00")
        let workouts = viewModel.workoutsForDay(testDate)
        
        // Then
        XCTAssertEqual(workouts.count, 2, "Должно быть 2 тренировки 25 ноября")
        XCTAssertEqual(workouts[0].workoutActivityType, .walkingRunning)
        XCTAssertEqual(workouts[1].workoutActivityType, .yoga)
    }

    func testHasWorkoutsOnDay() {
        // Given
        let testDate = dateFromString("2025-11-25 08:00:00")
        let testWorkout = Workout(
            id: "1",
            workoutActivityType: .water,
            workoutStartDate: testDate
        )
        
        // Создаем ViewModel с пустым сервисом
        let viewModel = CalendarViewModel(apiService: MockAPIService())
        
        // Устанавливаем данные НАПРЯМУЮ, без вызова loadWorkouts()
        // Это ключевой момент!
        viewModel.setTestWorkouts([testWorkout])
        
        // When & Then
        XCTAssertTrue(viewModel.hasWorkoutsOnDay(testDate),
                     "Должна быть тренировка 25 ноября")
        
        let dateWithoutWorkout = dateFromString("2025-11-26 12:00:00")
        XCTAssertFalse(viewModel.hasWorkoutsOnDay(dateWithoutWorkout),
                      "Не должно быть тренировки 26 ноября")
    }

    func testFetchWorkoutsForSpecificDate() async throws {
        // Given
        let testWorkouts = [
            Workout(
                id: "1",
                workoutActivityType: .strength,
                workoutStartDate: dateFromString("2025-11-25 09:30:00")
            ),
            Workout(
                id: "2",
                workoutActivityType: .cycling,
                workoutStartDate: dateFromString("2025-11-26 10:00:00")
            )
        ]
        
        let mockService = MockAPIService(workouts: testWorkouts)
        
        // When
        let date25 = dateFromString("2025-11-25 00:00:00")
        let workoutsFor25 = try await mockService.fetchWorkouts(for: date25)
        
        // Then
        XCTAssertEqual(workoutsFor25.count, 1)
        XCTAssertEqual(workoutsFor25.first?.workoutActivityType, .strength)
        
        let date26 = dateFromString("2025-11-26 00:00:00")
        let workoutsFor26 = try await mockService.fetchWorkouts(for: date26)
        XCTAssertEqual(workoutsFor26.count, 1)
        XCTAssertEqual(workoutsFor26.first?.workoutActivityType, .cycling)
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
    
    
    
    func testWorkoutDetailWithEmptyData() async throws {
        // Given
        let service = MockAPIService() // ваш новый Mock
        let workout = Workout(id: "empty", workoutActivityType: .walkingRunning, workoutStartDate: Date())
        let viewModel = WorkoutDetailViewModel(workout: workout, apiService: service)
        
        // Когда: загружаем данные
        viewModel.loadData()
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 секунды
        
        // Then: проверяем обработку отсутствия данных
        XCTAssertNotNil(viewModel.workout)
        XCTAssertNil(viewModel.metadata) // Сервис возвращает nil
        XCTAssertNil(viewModel.diagramData)
    }

    func testWorkoutDetailErrorHandling() async throws {
        // Given: сервис, который кидает ошибку
        class ErrorMockAPIService: APIServiceProtocol {
            func fetchWorkouts() async throws -> [Workout] { throw NSError(domain: "test", code: 1) }
            func fetchWorkouts(for date: Date) async throws -> [Workout] { throw NSError(domain: "test", code: 1) }
            func fetchMetadata(for workoutId: String) async throws -> WorkoutMetadata? { throw NSError(domain: "test", code: 1) }
            func fetchDiagramData(for workoutId: String) async throws -> [DiagramData]? { throw NSError(domain: "test", code: 1) }
        }
        
        let service = ErrorMockAPIService()
        let workout = Workout(id: "error", workoutActivityType: .walkingRunning, workoutStartDate: Date())
        let viewModel = WorkoutDetailViewModel(workout: workout, apiService: service)
        
        // When
        viewModel.loadData()
        try await Task.sleep(nanoseconds: 500_000_000)
        
        // Then: проверяем, что ViewModel не падает
        XCTAssertNotNil(viewModel)
    }

}





class MockAPIService: APIServiceProtocol {
    private var mockWorkouts: [Workout] = []
    private var mockWorkoutMetadata: [String: WorkoutMetadata] = [:]
    private var mockDiagramData: [String: [DiagramData]] = [:]
    
    init(
        workouts: [Workout] = [],
        metadata: [String: WorkoutMetadata] = [:],
        diagramData: [String: [DiagramData]] = [:]
    ) {
        self.mockWorkouts = workouts
        self.mockWorkoutMetadata = metadata
        self.mockDiagramData = diagramData
    }
    
    // 1. Все тренировки
    func fetchWorkouts() async throws -> [Workout] {
        return mockWorkouts
    }
    
    // 2. Тренировки для конкретной даты
    func fetchWorkouts(for date: Date) async throws -> [Workout] {
        let calendar = Calendar.current
        return mockWorkouts.filter { workout in
            calendar.isDate(workout.workoutStartDate, inSameDayAs: date)
        }
    }
    
    // 3. Метаданные для конкретной тренировки
    func fetchMetadata(for workoutId: String) async throws -> WorkoutMetadata? {
        return mockWorkoutMetadata[workoutId]
    }
    
    // 4. Данные диаграммы для тренировки
    func fetchDiagramData(for workoutId: String) async throws -> [DiagramData]? {
        return mockDiagramData[workoutId]
    }
    
    // Вспомогательные методы для настройки тестов
    func setWorkouts(_ workouts: [Workout]) {
        self.mockWorkouts = workouts
    }
    
    func addWorkout(_ workout: Workout) {
        mockWorkouts.append(workout)
    }
    
    func setMetadata(_ metadata: WorkoutMetadata, for workoutId: String) {
        mockWorkoutMetadata[workoutId] = metadata
    }
    
    func setDiagramData(_ data: [DiagramData], for workoutId: String) {
        mockDiagramData[workoutId] = data
    }
}



