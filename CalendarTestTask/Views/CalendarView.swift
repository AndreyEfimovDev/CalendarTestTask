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
    
    init(viewModel: CalendarViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    // Заголовок
                    CalendarHeader(
                        monthYear: viewModel.currentMonthYear,
                        onPrevious: viewModel.goToPreviousMonth,
                        onNext: viewModel.goToNextMonth,
                        onToday: {
                            // Кнопка "Сегодня" возвращает к ноябрю 2025
                            viewModel.currentDate = coordinator.initialCalendarDate
                        }
                    )
                    
                    // Сетка календаря
                    CalendarGridView(viewModel: viewModel)
                    
                    // Сегодняшние тренировки (только если показываем ноябрь 2025)
                    if Calendar.current.isDate(viewModel.currentDate, equalTo: coordinator.initialCalendarDate, toGranularity: .month) {
                        TodayWorkoutsSection(viewModel: viewModel)
                    }
                }
                .padding()
            }
            .navigationTitle("Календарь тренировок")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showingDayEvents) {
                NavigationStack {
                    coordinator.dayEventsView(for: viewModel.selectedDate)
                }
                .presentationDetents([.medium, .large])
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
