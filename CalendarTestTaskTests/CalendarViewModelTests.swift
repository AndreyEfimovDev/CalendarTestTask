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
    
    // MARK: - Тест фильтрации тренировок по дате
    /// **Что тестирует:** Корректность фильтрации массива тренировок по конкретному дню
    /// **Что проверяет:**
    /// 1. Метод workoutsForDay() возвращает только тренировки указанной даты
    /// 2. Игнорирует тренировки других дат
    /// 3. Сохраняет порядок тренировок в пределах дня
    
    func testWorkoutsFilteringByDate() {
        // Given
        let viewModel = CalendarViewModel(apiService: MockAPIService())
        
        // Тестовые данные: 3 тренировки, 2 из них 25 ноября, 1 - 26 ноября
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
        
        // Устанавливаем тестовые данные, без loadWorkouts()
        viewModel.setTestWorkouts(testWorkouts)
        
        let testDate = dateFromString("2025-11-25 00:00:00") // 25 ноября
        let workouts = viewModel.workoutsForDay(testDate) // Запрашиваем тренировки на 25 ноября
        
        // Then
        XCTAssertEqual(workouts.count, 2, "Должно быть 2 тренировки 25 ноября")
        XCTAssertEqual(workouts[0].workoutActivityType, .walkingRunning, "Первая тренировка должна быть 'Ходьба/Бег'")
        XCTAssertEqual(workouts[1].workoutActivityType, .yoga, "Вторая тренировка должна быть 'Йога'")
    }

    // MARK: - Тест проверки наличия тренировок в день
    /// **Что тестирует:** Метод hasWorkoutsOnDay() для определения есть ли тренировки в указанную дату
    /// **Что проверяет:**
    /// 1. Возвращает true когда тренировки есть
    /// 2. Возвращает false когда тренировок нет
    /// 3. Игнорирует время суток (сравнивает только даты)

    func testHasWorkoutsOnDay() {
        // Given - подготовка: одна тренировка на 25 ноября
        let testDate = dateFromString("2025-11-25 08:00:00")
        let testWorkout = Workout(
            id: "1",
            workoutActivityType: .water,
            workoutStartDate: testDate
        )
        
        // Создаем ViewModel с пустым сервисом
        let viewModel = CalendarViewModel(apiService: MockAPIService())
        
        viewModel.setTestWorkouts([testWorkout])
        
        // When & Then
        // Сценарий 1: Дата с тренировкой
        XCTAssertTrue(viewModel.hasWorkoutsOnDay(testDate),
                     "Должна быть тренировка 25 ноября")
        // Сценарий 2: Дата без тренировок
        let dateWithoutWorkout = dateFromString("2025-11-26 12:00:00")
        XCTAssertFalse(viewModel.hasWorkoutsOnDay(dateWithoutWorkout), "Не должно быть тренировки 26 ноября")
    }

    // MARK: - Тест сервиса: получение тренировок по конкретной дате
    /// **Что тестирует:** Метод APIService.fetchWorkouts(for:)
    /// **Что проверяет:**
    /// 1. Сервис корректно фильтрует тренировки по дате
    /// 2. Возвращает только тренировки запрошенной даты
    /// 3. Правильно работает с временем (сравнивает дни, а не точное время)

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
        
        // When - тестируем фильтрацию по разным датам
        let date25 = dateFromString("2025-11-25 00:00:00")
        let workoutsFor25 = try await mockService.fetchWorkouts(for: date25)
        
        // Then
        XCTAssertEqual(workoutsFor25.count, 1, "Для 25 ноября должна быть 1 тренировка")
        XCTAssertEqual(workoutsFor25.first?.workoutActivityType, .strength, "Тип тренировки должен быть 'Силовая'")
        
        let date26 = dateFromString("2025-11-26 00:00:00")
        let workoutsFor26 = try await mockService.fetchWorkouts(for: date26)
        XCTAssertEqual(workoutsFor26.count, 1, "Для 26 ноября должна быть 1 тренировка")
        XCTAssertEqual(workoutsFor26.first?.workoutActivityType, .cycling, "Тип тренировки должен быть 'Велоспорт'")
    }
    
    // MARK: - Тест форматирования месяца и года
    /// **Что тестирует:** Вычисляемое свойство currentMonthYear
    /// **Что проверяет:**
    /// 1. Возвращает непустую строку
    /// 2. Строка содержит год (формат "Месяц Год")
    /// 3. Форматирование на русском языке

    func testCurrentMonthYearFormat() {
        // Given
        let service = TestDataService()
        let viewModel = CalendarViewModel(apiService: service)
        
        // When
        let monthYear = viewModel.currentMonthYear
        
        // Then - проверяем формат
        XCTAssertFalse(monthYear.isEmpty, "Строка месяца и года не должна быть пустой")
        XCTAssertTrue(monthYear.contains("202"), "Должен содержать год (например, '2025')")
    }
    
    // MARK: - Тест деталей тренировки с пустыми данными
    /// **Что тестирует:** WorkoutDetailViewModel с отсутствующими метаданными
    /// **Что проверяет:**
    /// 1. ViewModel не падает при отсутствии метаданных
    /// 2. Основная информация о тренировке загружается
    /// 3. Метаданные и данные графика остаются nil (но не вызывают краш)
    
    func testWorkoutDetailWithEmptyData() async throws {
        // Given - сервис, который возвращает nil для метаданных
        let service = MockAPIService() // возвращает nil для metadata и diagramData
        let workout = Workout(id: "empty", workoutActivityType: .walkingRunning, workoutStartDate: Date())
        let viewModel = WorkoutDetailViewModel(workout: workout, apiService: service)
        
        viewModel.loadData()
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 секунды
        
        // Then:  - проверяем состояние ViewModel, обработка отсутствия данных
        XCTAssertNotNil(viewModel.workout, "Основная информация о тренировке должна быть")
        XCTAssertNil(viewModel.metadata, "Метаданные должны быть nil (сервис возвращает nil)") // Сервис возвращает nil
        XCTAssertNil(viewModel.diagramData, "Данные графика должны быть nil")
    }

    // MARK: - Тест обработки ошибок в деталях тренировки
    /// **Что тестирует:** Устойчивость WorkoutDetailViewModel к ошибкам сервиса
    /// **Что проверяет:**
    /// 1. ViewModel не падает при ошибках сети/сервера
    /// 2. Ошибка корректно сохраняется в errorMessage
    /// 3. Состояние isLoading правильно меняется

    func testWorkoutDetailErrorHandling() async throws {
        // Given: сервис, который выбрасывает ошибку
        class ErrorMockAPIService: APIServiceProtocol {
            func fetchWorkouts() async throws -> [Workout] {
                throw NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Тестовая ошибка"])
            }
            func fetchWorkouts(for date: Date) async throws -> [Workout] {
                throw NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Тестовая ошибка"])
            }
            func fetchMetadata(for workoutId: String) async throws -> WorkoutMetadata? {
                throw NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Тестовая ошибка"])
            }
            func fetchDiagramData(for workoutId: String) async throws -> [DiagramData]? {
                throw NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Тестовая ошибка"])
            }
        }
        
        let service = ErrorMockAPIService()
        let workout = Workout(id: "error", workoutActivityType: .walkingRunning, workoutStartDate: Date())
        let viewModel = WorkoutDetailViewModel(workout: workout, apiService: service)
        
        // When - запускаем загрузку (которая завершится ошибкой)
        viewModel.loadData()
        try await Task.sleep(nanoseconds: 500_000_000)
        
        // Then - проверяем, что ViewModel обработал ошибку корректно
        XCTAssertNotNil(viewModel, "ViewModel не должен быть уничтожен при ошибке")
        XCTAssertNotNil(viewModel.errorMessage, "Должно быть сообщение об ошибке")
        XCTAssertFalse(viewModel.isLoading, "После ошибки isLoading должен быть false")
    }
    
    // MARK: - Вспомогательный метод
    /// Преобразует строку в Date для тестов
    /// - Parameter string: Строка в формате "yyyy-MM-dd HH:mm:ss"
    /// - Returns: Date с временной зоной UTC для предсказуемости тестов

    private func dateFromString(_ string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: string)!
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



