////
////  DayEventsView.swift
////  CalendarTestTask
////
////  Created by Andrey Efimov on 12.12.2025.
////
//
//import SwiftUI
//
//struct DayEventsView: View {
//    
//    @StateObject private var viewModel: DayEventsViewModel
//    @EnvironmentObject private var coordinator: AppCoordinator
//    @Environment(\.dismiss) private var dismiss
//    @State private var selectedWorkout: Workout? // Для навигации к деталям
//    
//    init(viewModel: DayEventsViewModel) {
//        _viewModel = StateObject(wrappedValue: viewModel)
//    }
//    
//    var body: some View {
//        Group {
//            if viewModel.isLoading {
//                LoadingView()
//            } else if viewModel.workouts.isEmpty {
//                emptyStateView
//            } else {
//                workoutsList
//            }
//        }
//        .navigationTitle(viewModel.formattedDate)
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button("Готово") {
//                    dismiss()
//                }
//            }
//        }
//        .sheet(item: $selectedWorkout) { workout in
//            NavigationStack {
//                coordinator.workoutDetailView(for: workout)
//            }
//            .presentationDetents([.medium, .large])
//        }
//        .alert("Ошибка", isPresented: .constant(viewModel.errorMessage != nil)) {
//            Button("OK") { viewModel.errorMessage = nil }
//        } message: {
//            Text(viewModel.errorMessage ?? "")
//        }
//    }
//    
//    private var emptyStateView: some View {
//        VStack(spacing: 20) {
//            Image(systemName: "figure.walk")
//                .font(.system(size: 60))
//                .foregroundColor(.gray)
//            
//            Text("Нет тренировок")
//                .font(.title2)
//                .foregroundColor(.secondary)
//            
//            Text("В этот день не было тренировок")
//                .font(.body)
//                .foregroundColor(.gray)
//                .multilineTextAlignment(.center)
//        }
//        .padding()
//    }
//    
//    private var workoutsList: some View {
//        List(viewModel.workouts) { workout in
//            WorkoutCard(workout: workout)
//                .onTapGesture {
//                    selectedWorkout = workout
//                }
//        }
//        .listStyle(.plain)
//    }
//}
//
//#Preview("25 ноября - 2 тренировки") {
//    let apiService = MockDataService()
//    let coordinator = AppCoordinator(apiService: apiService)
//    
//    // 25 ноября 2025 - Walking/Running и Yoga
//    var dateComponents = DateComponents()
//    dateComponents.year = 2025
//    dateComponents.month = 11
//    dateComponents.day = 25
//    let date = Calendar.current.date(from: dateComponents) ?? Date()
//    
//    let viewModel = DayEventsViewModel(
//        date: date,
//        apiService: apiService
//    )
//    
//    return NavigationStack {
//        DayEventsView(viewModel: viewModel)
//            .environmentObject(coordinator)
//    }
//}
//
//#Preview("24 ноября - 2 тренировки") {
//    let apiService = MockDataService()
//    let coordinator = AppCoordinator(apiService: apiService)
//    
//    // 24 ноября 2025 - Water и Walking/Running
//    var dateComponents = DateComponents()
//    dateComponents.year = 2025
//    dateComponents.month = 11
//    dateComponents.day = 24
//    let date = Calendar.current.date(from: dateComponents) ?? Date()
//    
//    let viewModel = DayEventsViewModel(
//        date: date,
//        apiService: apiService
//    )
//    
//    return NavigationStack {
//        DayEventsView(viewModel: viewModel)
//            .environmentObject(coordinator)
//    }
//}
//
//#Preview("22 ноября - 2 тренировки") {
//    let apiService = MockDataService()
//    let coordinator = AppCoordinator(apiService: apiService)
//    
//    // 22 ноября 2025 - Walking/Running и Yoga
//    var dateComponents = DateComponents()
//    dateComponents.year = 2025
//    dateComponents.month = 11
//    dateComponents.day = 22
//    let date = Calendar.current.date(from: dateComponents) ?? Date()
//    
//    let viewModel = DayEventsViewModel(
//        date: date,
//        apiService: apiService
//    )
//    
//    return NavigationStack {
//        DayEventsView(viewModel: viewModel)
//            .environmentObject(coordinator)
//    }
//}
//
//#Preview("21 ноября - 2 тренировки") {
//    let apiService = MockDataService()
//    let coordinator = AppCoordinator(apiService: apiService)
//    
//    // 21 ноября 2025 - Water и Strength
//    var dateComponents = DateComponents()
//    dateComponents.year = 2025
//    dateComponents.month = 11
//    dateComponents.day = 21
//    let date = Calendar.current.date(from: dateComponents) ?? Date()
//    
//    let viewModel = DayEventsViewModel(
//        date: date,
//        apiService: apiService
//    )
//    
//    return NavigationStack {
//        DayEventsView(viewModel: viewModel)
//            .environmentObject(coordinator)
//    }
//}
//
//#Preview("23 ноября - 1 тренировка") {
//    let apiService = MockDataService()
//    let coordinator = AppCoordinator(apiService: apiService)
//    
//    // 23 ноября 2025 - только Cycling
//    var dateComponents = DateComponents()
//    dateComponents.year = 2025
//    dateComponents.month = 11
//    dateComponents.day = 23
//    let date = Calendar.current.date(from: dateComponents) ?? Date()
//    
//    let viewModel = DayEventsViewModel(
//        date: date,
//        apiService: apiService
//    )
//    
//    return NavigationStack {
//        DayEventsView(viewModel: viewModel)
//            .environmentObject(coordinator)
//    }
//}
//
//#Preview("Пустое состояние - 20 ноября") {
//    let apiService = MockDataService()
//    let coordinator = AppCoordinator(apiService: apiService)
//    
//    // 20 ноября 2025 - нет тренировок
//    var dateComponents = DateComponents()
//    dateComponents.year = 2025
//    dateComponents.month = 11
//    dateComponents.day = 20
//    let date = Calendar.current.date(from: dateComponents) ?? Date()
//    
//    let viewModel = DayEventsViewModel(
//        date: date,
//        apiService: apiService
//    )
//    
//    return NavigationStack {
//        DayEventsView(viewModel: viewModel)
//            .environmentObject(coordinator)
//    }
//}
//
//#Preview("Загрузка") {
//    // Mock сервис с задержкой
//    class LoadingMockService: APIServiceProtocol {
//        func fetchWorkouts() async throws -> [Workout] {
//            try await Task.sleep(nanoseconds: 10_000_000_000)
//            return []
//        }
//        func fetchWorkouts(for date: Date) async throws -> [Workout] {
//            try await Task.sleep(nanoseconds: 10_000_000_000)
//            return []
//        }
//        func fetchMetadata(for workoutId: String) async throws -> WorkoutMetadata? { nil }
//        func fetchDiagramData(for workoutId: String) async throws -> [DiagramData]? { nil }
//    }
//    
//    let apiService = LoadingMockService()
//    let coordinator = AppCoordinator(apiService: apiService)
//    
//    var dateComponents = DateComponents()
//    dateComponents.year = 2025
//    dateComponents.month = 11
//    dateComponents.day = 25
//    let date = Calendar.current.date(from: dateComponents) ?? Date()
//    
//    let viewModel = DayEventsViewModel(
//        date: date,
//        apiService: apiService
//    )
//    
//    return NavigationStack {
//        DayEventsView(viewModel: viewModel)
//            .environmentObject(coordinator)
//    }
//}
