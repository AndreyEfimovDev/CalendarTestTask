//
//  DayEventsView.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import SwiftUI

struct DayEventsView: View {
    
    @StateObject private var viewModel: DayEventsViewModel
    @EnvironmentObject private var coordinator: AppCoordinator
    @Environment(\.dismiss) private var dismiss
    @State private var selectedWorkout: Workout? // Для навигации к деталям
    
    init(viewModel: DayEventsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.workouts.isEmpty {
                emptyStateView
            } else {
                workoutsList
            }
        }
        .navigationTitle(viewModel.formattedDate)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Готово") {
                    dismiss()
                }
            }
        }
        .sheet(item: $selectedWorkout) { workout in
            NavigationStack {
                coordinator.workoutDetailView(for: workout)
            }
            .presentationDetents([.medium, .large])
        }
        .alert("Ошибка", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.walk")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Нет тренировок")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("В этот день не было тренировок")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private var workoutsList: some View {
        List(viewModel.workouts) { workout in
            WorkoutCard(workout: workout)
                .onTapGesture {
                    selectedWorkout = workout
                }
        }
        .listStyle(.plain)
    }
}

#Preview {
    let apiService = MockDataService()
    let coordinator = AppCoordinator(apiService: apiService)
    let viewModel = DayEventsViewModel(
        date: Date(),
        apiService: apiService
    )
    
    return NavigationStack {
        DayEventsView(viewModel: viewModel)
            .environmentObject(coordinator)
    }
}
