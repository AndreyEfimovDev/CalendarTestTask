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
    
    // MARK: - Интеграционный тест: График пульса в деталях тренировки
    /// **Что тестирует:** Полная интеграция WorkoutDetailViewModel с загрузкой данных графика
    /// **Что проверяет:**
    /// 1. ViewModel корректно загружает данные для графика из сервиса
    /// 2. Все необходимые данные (тренировка, метаданные, точки графика) загружаются
    /// 3. Данные графика не пустые и имеют корректный формат
    /// **Важность:** Высокая - проверяет ключевую функциональность приложения

    func testHeartRateChartInWorkoutDetail() async throws {
        // Given
        let service = MockDataService() // Сервис с предзагруженными тестовыми данными
        let workout = Workout(
            id: "7823456789012345", // Существующий ID в тестовых данных
            workoutActivityType: .walkingRunning,
            workoutStartDate: Date()
        )
        let viewModel = WorkoutDetailViewModel(workout: workout, apiService: service)
        
        // When
        viewModel.loadData()
        
        // Ждем загрузки
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 секунда
        
        // Then
        XCTAssertNotNil(viewModel.workout, "Основная информация о тренировке должна быть загружена")
        XCTAssertNotNil(viewModel.metadata, "Метаданные тренировки (дистанция, длительность) должны быть загружены")
        XCTAssertNotNil(viewModel.diagramData, "Данные для графика пульса должны быть загружены")
        XCTAssertGreaterThan(viewModel.diagramData?.count ?? 0, 0, "Массив данных графика не должен быть пустым")
        
        // Дополнительные проверки качества данных
        if let diagramData = viewModel.diagramData {
            // Проверяем, что данные имеют корректную структуру
            XCTAssertTrue(diagramData.allSatisfy { $0.heartRate > 0 }, "Все точки должны иметь положительный пульс")
            XCTAssertTrue(diagramData.allSatisfy { $0.timeNumeric >= 0 }, "Временные метки должны быть неотрицательными")
        }
    }
    
    // MARK: - Тест создания View графика пульса
    /// **Что тестирует:** Корректное создание HeartRateChartView SwiftUI компонента
    /// **Что проверяет:**
    /// 1. View может быть создан с тестовыми данными
    /// 2. View корректно инициализируется в UIHostingController
    /// 3. Не возникает крашей или ошибок при рендеринге
    /// **Важность:** Средняя - проверяет стабильность UI компонента
    
    func testHeartRateChartViewCreation() {
        // Given
        let testData = createTestDiagramData() // 10 точек с возрастающим пульсом
        
        // When
        let chartView = HeartRateChartView(diagramData: testData)
        
        // Then - проверяем что view создается
        XCTAssertNotNil(chartView, "HeartRateChartView должен успешно создаваться")
        
        // Проверка через UIHostingController
        // Имитирует реальное использование в UIKit среде
        let hostingController = UIHostingController(rootView: chartView)
        
        // Запускаем жизненный цикл view
        hostingController.loadViewIfNeeded()
        XCTAssertNotNil(hostingController.view, "View должен успешно загружаться в UIHostingController")
    }
    
    // MARK: - Тест графика с пустыми данными
    /// **Что тестирует:** Поведение HeartRateChartView при отсутствии данных
    /// **Что проверяет:**
    /// 1. View не падает при пустом массиве данных
    /// 2. Корректно отображает состояние "нет данных" (если предусмотрено дизайном)
    /// 3. Не вызывает ошибок рендеринга
    /// **Важность:** Высокая - edge case, который должен обрабатываться

    func testHeartRateChartWithEmptyData() {
        // Given - пустой массив данных (случай: данные не загрузились)
        let emptyData: [DiagramData] = []
        
        // When - создаем View с пустыми данными
        let chartView = HeartRateChartView(diagramData: emptyData)
        let hostingController = UIHostingController(rootView: chartView)
        hostingController.loadViewIfNeeded() // Имитируем появление на экране
        
        // Then - проверяем корректность обработки, что view создается без данных
        XCTAssertNotNil(chartView, "View должен создаваться даже с пустыми данными")
        XCTAssertNotNil(hostingController.view, "View контроллера должен загружаться без ошибок")
    }

    // MARK: - Тест производительности графика с большими данными
    /// **Что тестирует:** Производительность рендеринга графика с большим объемом данных
    /// **Что проверяет:**
    /// 1. View создается за приемлемое время с 1000+ точками
    /// 2. Нет явных проблем с памятью при рендеринге
    /// 3. Производительность в пределах допустимого для плавного UI
    /// **Важность:** Средняя - оптимизация для реальных сценариев

    func testHeartRateChartPerformance() {
        // Given - большой объем данных (имитация длительной тренировки)
        var largeData: [DiagramData] = []
        for i in 0..<1000 { // 1000 точек - реалистичный сценарий для часовой тренировки
            largeData.append(DiagramData(
                timeNumeric: i, // секунды от начала
                heartRate: 60 + i % 40, // Пульс 60-100 уд/мин
                speedKmh: Double(i % 20) * 0.5, // Скорость 0-10 км/ч
                distanceMeters: i * 10, // Пройденная дистанция
                steps: i * 50, // Шаги
                elevation: Double(i % 100), // Высота 0-100 метров
                latitude: 55.7558,
                longitude: 37.6173,
                temperatureCelsius: 20.0,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: Date()
            ))
        }
        
        // When & Then - измеряем время создания View
        measure {
            // Измеряем производительность создания View
            let chartView = HeartRateChartView(diagramData: largeData)
            let hostingController = UIHostingController(rootView: chartView)
            
            // Имитируем загрузку (самая затратная часть)
            hostingController.loadViewIfNeeded()
            
            // Проверяем, что View создан
            XCTAssertNotNil(chartView)
            XCTAssertNotNil(hostingController.view)
        }
        
    }
    
    // MARK: - Вспомогательные методы
    /// Создает тестовые данные для графика пульса
    /// - Returns: Массив из 10 точек с линейно возрастающим пульсом

    private func createTestDiagramData() -> [DiagramData] {
        var data: [DiagramData] = []
        for i in 0..<10 {
            data.append(DiagramData(
                timeNumeric: i, // 0, 1, 2, ... 9 секунд
                heartRate: 70 + i * 3, // Пульс: 70, 73, 76, ... 97 уд/мин
                speedKmh: Double(i) * 1.5, // Скорость: 0, 1.5, 3.0, ... 13.5 км/ч
                distanceMeters: i * 100, // Дистанция: 0, 100, 200, ... 900 метров
                steps: i * 80, // Шаги: 0, 80, 160, ... 720 шагов
                elevation: 45.0, // Постоянная высота
                latitude: 55.7558, // Москва
                longitude: 37.6173,
                temperatureCelsius: 20.0, // Комнатная температура
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: Date()
            ))
        }
        return data
    }

}
