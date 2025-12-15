//
//  WorkoutDetailView.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import SwiftUI

struct WorkoutDetailView: View {
    
    @StateObject private var viewModel: WorkoutDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: WorkoutDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if let workout = viewModel.workout {
                    // Заголовок
                    headerSection(workout: workout)
                    
                    // Основная информация
                    if let metadata = viewModel.metadata {
                        Divider()
                        
                        // Дистанция и длительность
                        statsSection(metadata: metadata)
                        
                        // Комментарий
                        if let comment = metadata.comment, !comment.isEmpty {
                            Divider()
                            commentSection(comment: comment)
                        }
                        
                        // Погода
                        Divider()
                        weatherSection(metadata: metadata)
                    }
                    
                    // График пульса (бонус - будет позже)
                    if let diagramData = viewModel.diagramData, !diagramData.isEmpty {
                        Divider()
                        heartRateSection(diagramData: diagramData)
                    }
                } else if viewModel.isLoading {
                    LoadingView()
                } else {
                    errorView
                }
            }
            .padding()
        }
        .navigationTitle("Детали тренировки")
        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button("Готово") {
//                    dismiss()
//                }
//            }
//        }
        .alert("Ошибка", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    // MARK: - Sections
    
    private func headerSection(workout: Workout) -> some View {
        HStack(spacing: 16) {
            Image(systemName: workout.workoutActivityType.icon)
                .font(.system(size: 40))
                .foregroundColor(workout.workoutActivityType.color)
                .frame(width: 60, height: 60)
                .background(workout.workoutActivityType.color.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.workoutActivityType.localizedName)
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                
                Text(viewModel.formattedDate)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
    
    private func statsSection(metadata: WorkoutMetadata) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Основные показатели")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                // Дистанция
                VStack(alignment: .leading, spacing: 4) {
                    Text("Дистанция")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(metadata.formattedDistance)
                        .font(.title3.bold())
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                // Длительность
                VStack(alignment: .leading, spacing: 4) {
                    Text("Длительность")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(metadata.formattedDuration)
                        .font(.title3.bold())
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                // Слои
                VStack(alignment: .leading, spacing: 4) {
                    Text("Слои")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(metadata.maxLayer + 1)")
                        .font(.title3.bold())
                        .foregroundColor(.orange)
                }
            }
        }
    }
    
    private func commentSection(comment: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Комментарий")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(comment)
                .font(.body)
                .foregroundColor(.secondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private func weatherSection(metadata: WorkoutMetadata) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Погодные условия")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 4) {
                    Label("Температура", systemImage: "thermometer")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(metadata.formattedTemperature)
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Label("Влажность", systemImage: "humidity")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(metadata.formattedHumidity)
                        .font(.title3)
                        .foregroundColor(.primary)
                }
            }
        }
    }
    
    private func heartRateSection(diagramData: [DiagramData]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Пульс во время тренировки")
                .font(.headline)
                .foregroundColor(.primary)
            
            HeartRateChartView(diagramData: diagramData)
            
            // Статистика пульса
            if !diagramData.isEmpty {
                VStack(spacing: 12) {
                    Divider()
                    
                    Text("Статистика пульса")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 20) {
                        StatItem(
                            title: "Средний",
                            value: "\(calculateAverageHeartRate(diagramData))",
                            unit: "уд/мин",
                            color: .blue
                        )
                        
                        Divider()
                            .frame(height: 30)
                        
                        StatItem(
                            title: "Максимальный",
                            value: "\(calculateMaxHeartRate(diagramData))",
                            unit: "уд/мин",
                            color: .red
                        )
                        
                        Divider()
                            .frame(height: 30)
                        
                        StatItem(
                            title: "Минимальный",
                            value: "\(calculateMinHeartRate(diagramData))",
                            unit: "уд/мин",
                            color: .green
                        )
                    }
                }
            }
        }
    }

    private var errorView: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("Тренировка не найдена")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Button("Повторить") {
                viewModel.loadData()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    // Вспомогательная функция для расчета среднего пульса
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
    
    // Дополнительно: можно добавить функцию для расчета средней скорости
    private func calculateAverageSpeed(_ data: [DiagramData]) -> Double {
        guard !data.isEmpty else { return 0 }
        let sum = data.reduce(0.0) { $0 + $1.speedKmh }
        return sum / Double(data.count)
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(color)
            
            Text(unit)
                .font(.caption2)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
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
