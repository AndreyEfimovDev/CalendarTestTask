//
//  WorkoutDetailView.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import SwiftUI

struct DayEventsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: WorkoutDetailViewModel
    
    init(viewModel: WorkoutDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if let workout = viewModel.workout {
                    headerSection(workout: workout)
                    
                    if let metadata = viewModel.metadata {
                        Divider()
                        
                        statsSection(metadata: metadata)
                        
                        if let comment = metadata.comment, !comment.isEmpty {
                            Divider()
                            commentSection(comment: comment)
                        }
                        
                        Divider()
                        weatherSection(metadata: metadata)
                    }
                    
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundStyle(Color.mycolor.myAccent)
                        .frame(width: 30, height: 30)
                        .background(.black.opacity(0.001))
                }
            }
        }
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
                    .foregroundColor(Color.mycolor.myAccent)
                
                Text(viewModel.formattedDate)
                    .font(.body)
                    .foregroundColor(Color.mycolor.mySecondary)
            }
            
            Spacer()
        }
    }
    
    private func statsSection(metadata: WorkoutMetadata) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Основные показатели")
                .font(.headline)
                .foregroundColor(Color.mycolor.myAccent)
            
            HStack(spacing: 20) {
                // Дистанция
                VStack(alignment: .leading, spacing: 4) {
                    Text("Дистанция")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(metadata.formattedDistance)
                        .font(.title3.bold())
                        .foregroundColor(Color.mycolor.myBlue)
                }
                
                Spacer()
                
                // Длительность
                VStack(alignment: .leading, spacing: 4) {
                    Text("Длительность")
                        .font(.caption)
                        .foregroundColor(Color.mycolor.mySecondary)
                    Text(metadata.formattedDuration)
                        .font(.title3.bold())
                        .foregroundColor(Color.mycolor.myGreen)
                }
                
                Spacer()
                
                // Слои
                VStack(alignment: .leading, spacing: 4) {
                    Text("Слои")
                        .font(.caption)
                        .foregroundColor(Color.mycolor.mySecondary)
                    Text("\(metadata.maxLayer + 1)")
                        .font(.title3.bold())
                        .foregroundColor(Color.mycolor.myOrange)
                }
            }
        }
    }
    
    private func commentSection(comment: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Комментарий")
                .font(.headline)
                .foregroundColor(Color.mycolor.myAccent)
            
            Text(comment)
                .font(.body)
                .foregroundColor(Color.mycolor.mySecondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.mycolor.mySecondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private func weatherSection(metadata: WorkoutMetadata) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Погодные условия")
                .font(.headline)
                .foregroundColor(Color.mycolor.myAccent)
            
            HStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 4) {
                    Label("Температура", systemImage: "thermometer")
                        .font(.caption)
                        .foregroundColor(Color.mycolor.mySecondary)
                    Text(metadata.formattedTemperature)
                        .font(.title3)
                        .foregroundColor(Color.mycolor.myAccent)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Label("Влажность", systemImage: "humidity")
                        .font(.caption)
                        .foregroundColor(Color.mycolor.mySecondary)
                    Text(metadata.formattedHumidity)
                        .font(.title3)
                        .foregroundColor(Color.mycolor.myAccent)
                }
            }
        }
    }
    
    private func heartRateSection(diagramData: [DiagramData]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Пульс во время тренировки")
                .font(.headline)
                .foregroundColor(Color.mycolor.myAccent)
            
            HeartRateChartView(diagramData: diagramData)
            
            // Статистика пульса
            if !diagramData.isEmpty {
                VStack(spacing: 12) {
                    Divider()
                    
                    Text("Статистика пульса")
                        .font(.subheadline)
                        .foregroundColor(Color.mycolor.myAccent)
                    
                    HStack(spacing: 20) {
                        StatItem(
                            title: "Средний",
                            value: "\(calculateAverageHeartRate(diagramData))",
                            unit: "уд/мин",
                            color: Color.mycolor.myBlue
                        )
                        
                        Divider()
                            .frame(height: 30)
                        
                        StatItem(
                            title: "Максимальный",
                            value: "\(calculateMaxHeartRate(diagramData))",
                            unit: "уд/мин",
                            color: Color.mycolor.myRed
                        )
                        
                        Divider()
                            .frame(height: 30)
                        
                        StatItem(
                            title: "Минимальный",
                            value: "\(calculateMinHeartRate(diagramData))",
                            unit: "уд/мин",
                            color: Color.mycolor.myGreen
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
                .foregroundColor(Color.mycolor.myOrange)
            
            Text("Тренировка не найдена")
                .font(.title2)
                .foregroundColor(Color.mycolor.mySecondary)
            
            Button("Повторить") {
                viewModel.loadData()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    // Расчет среднего пульса
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
    
    // Расчет средней скорости
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
        DayEventsView(viewModel: viewModel)
            .environmentObject(coordinator)
    }
}
