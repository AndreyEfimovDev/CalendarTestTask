//
//  WorkoutDetailViewModel.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import Foundation
import SwiftUI
internal import Combine

@MainActor
class WorkoutDetailViewModel: ObservableObject {
    @Published var workout: Workout?
    @Published var metadata: WorkoutMetadata?
    @Published var diagramData: [DiagramData]?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let workoutId: String?
    private let apiService: APIServiceProtocol
    
    // Инициализатор по workout
    init(workout: Workout, apiService: APIServiceProtocol) {
        self.workout = workout
        self.workoutId = workout.id
        self.apiService = apiService
        loadData()
    }
    
    // Инициализатор по workoutId
    init(workoutId: String, apiService: APIServiceProtocol) {
        self.workoutId = workoutId
        self.apiService = apiService
        loadData()
    }
    
    func loadData() {
        guard let workoutId = workoutId else { return }
        
        Task {
            isLoading = true
            errorMessage = nil
            
            print("🔄 Загрузка деталей тренировки \(workoutId)...")
            
            do {
                // Если workout не загружен, загружаем его
                if workout == nil {
                    let allWorkouts = try await apiService.fetchWorkouts()
                    workout = allWorkouts.first { $0.id == workoutId }
                    print("✅ Тренировка найдена: \(workout?.workoutActivityType.localizedName ?? "неизвестно")")
                }
                
                // Загружаем метаданные
                metadata = try await apiService.fetchMetadata(for: workoutId)
                print("✅ Метаданные загружены: \(metadata != nil ? "да" : "нет")")
                
                // ЗАГРУЖАЕМ ДАННЫЕ ДЛЯ ГРАФИКА (важно!)
                diagramData = try await apiService.fetchDiagramData(for: workoutId)
                print("✅ Данные графика загружены: \(diagramData?.count ?? 0) точек")
                
            } catch let apiError as APIError {
                errorMessage = apiError.description
                print("❌ Ошибка загрузки деталей: \(apiError.description)")
            } catch {
                errorMessage = "Ошибка загрузки данных"
                print("❌ Неизвестная ошибка: \(error)")
            }
            
            isLoading = false
        }
    }

    var formattedDate: String {
        guard let date = workout?.workoutStartDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
    
    private func heartRateSection(diagramData: [DiagramData]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Пульс")
                .font(.headline)
                .foregroundColor(Color.mycolor.myAccent)
            
            HeartRateChartView(diagramData: diagramData)
            
            // Статистика
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Средний")
                        .font(.caption)
                        .foregroundColor(Color.mycolor.mySecondary)
                    Text("\(calculateAverageHeartRate(diagramData)) уд/мин")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.mycolor.myRed)
                }
                
                Divider()
                    .frame(height: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Максимальный")
                        .font(.caption)
                        .foregroundColor(Color.mycolor.mySecondary)
                    Text("\(calculateMaxHeartRate(diagramData)) уд/мин")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.mycolor.myRed)
                }
                
                Divider()
                    .frame(height: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Минимальный")
                        .font(.caption)
                        .foregroundColor(Color.mycolor.mySecondary)
                    Text("\(calculateMinHeartRate(diagramData)) уд/мин")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.mycolor.myRed)
                }
            }
            .padding(.top, 8)
        }
    }

    // Добавляем вспомогательные функции:
    private func calculateAverageHeartRate(_ data: [DiagramData]) -> Int {
        guard !data.isEmpty else { return 0 }
        let sum = data.reduce(0) { $0 + $1.heartRate }
        return sum / data.count
    }

    private func calculateMaxHeartRate(_ data: [DiagramData]) -> Int {
        data.map { $0.heartRate }.max() ?? 0
    }

    private func calculateMinHeartRate(_ data: [DiagramData]) -> Int {
        data.map { $0.heartRate }.min() ?? 0
    }

}
