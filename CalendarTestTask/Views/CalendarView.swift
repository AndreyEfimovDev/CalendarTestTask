//
//  CalendarView.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import SwiftUI

struct CalendarView: View {
    
    @StateObject private var viewModel: CalendarViewModel
    @EnvironmentObject private var coordinator: AppCoordinator
    
    @State private var showPreferancesView: Bool = false
    
    init(viewModel: CalendarViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Загрузка тренировок...")
                        .padding()
                } else {
                    CalendarHeader(
                        monthYear: viewModel.currentMonthYear,
                        onPrevious: viewModel.goToPreviousMonth,
                        onNext: viewModel.goToNextMonth,
                        onToday: {
                            viewModel.currentDate = coordinator.initialCalendarDate
                            viewModel.resetSelectedDate()
                        }
                    )
                    
                    CalendarGridView(viewModel: viewModel)
                    
                    DayWorkoutsSection(
                        date: viewModel.selectedDate ?? coordinator.initialCalendarDate,
                        workouts: viewModel.workoutsForDay(
                            viewModel.selectedDate ?? coordinator.initialCalendarDate
                        )
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Календарь тренировок")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showPreferancesView.toggle()
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .fullScreenCover(isPresented: $showPreferancesView) {
            NavigationStack {
                PreferencesView()
            }
        }
        .overlay {
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .alert("Ошибка", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
            Button("Повторить") {
                viewModel.loadWorkouts()
            }
        } message: {
            Text(viewModel.errorMessage ?? "Неизвестная ошибка")
        }
        .onAppear {
            // Восстанавливаем состояние при возврате
            viewModel.syncWithCoordinator()
        }
    }
}

#Preview {
    let apiService = MockDataService()
    let coordinator = AppCoordinator(apiService: apiService)
    let viewModel = CalendarViewModel(
        apiService: apiService,
        initialDate: coordinator.initialCalendarDate
    )
    
    return NavigationStack {
        CalendarView(viewModel: viewModel)
            .environmentObject(coordinator)
    }
}
