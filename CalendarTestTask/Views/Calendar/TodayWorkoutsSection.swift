//
//  TodayWorkoutsSection.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import SwiftUI

struct TodayWorkoutsSection: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    init(viewModel: CalendarViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    private var hasWorkoutsToday: Bool {
        return !viewModel.workoutsForDay(Date()).isEmpty
    }
    
//    private func hasWorkoutsOnDay(_ date: Date) -> Bool {
//        return !viewModel.workoutsForDay(date).isEmpty
//    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Тренировки сегодня")
                    .font(.headline)
                    .foregroundColor(Color.mycolor.myAccent)
                
                Spacer()
                
                if hasWorkoutsToday {
                    Button("Все") {
                        withAnimation {
                            viewModel.selectDate(Date())
                        }
                    }
                    .font(.caption)
                    .foregroundColor(Color.mycolor.myBlue)
                }
            }
            
            if hasWorkoutsToday { // Используем вычисляемое свойство
                let todaysWorkouts = viewModel.workoutsForDay(Date())
                VStack(spacing: 8) {
                    ForEach(todaysWorkouts.prefix(3)) { workout in
                        WorkoutCard(workout: workout)
                    }
                    
                    if todaysWorkouts.count > 3 {
                        Text("и еще \(todaysWorkouts.count - 3) тренировок")
                            .font(.caption)
                            .foregroundColor(Color.mycolor.myAccent)
                    }
                }
            } else {
                Text("Сегодня нет тренировок")
                    .font(.subheadline)
                    .foregroundColor(Color.mycolor.myAccent)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding()
        .background(Color.mycolor.mySecondary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}


#Preview("С одной тренировкой") {
    class SingleWorkoutAPIService: APIServiceProtocol {
        func fetchWorkouts() async throws -> [Workout] {
            return [
                Workout(
                    id: "1",
                    workoutActivityType: .yoga,
                    workoutStartDate: Date()
                )
            ]
        }
        
        func fetchWorkouts(for date: Date) async throws -> [Workout] {
            return try await fetchWorkouts()
        }
        
        func fetchMetadata(for workoutId: String) async throws -> WorkoutMetadata? {
            return nil
        }
        
        func fetchDiagramData(for workoutId: String) async throws -> [DiagramData]? {
            return nil
        }
    }
    
    let service = SingleWorkoutAPIService()
    let viewModel = CalendarViewModel(apiService: service)
    
    return TodayWorkoutsSection(viewModel: viewModel)
        .padding()
        .background(Color.gray.opacity(0.05))
}



