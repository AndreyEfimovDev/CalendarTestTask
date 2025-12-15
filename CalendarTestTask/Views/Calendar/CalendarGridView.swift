//
//  CalendarGridView.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import SwiftUI

struct CalendarGridView: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    private let weekdays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    
    var body: some View {
        VStack(spacing: 12) {
            // Дни недели
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .font(.caption)
                        .foregroundColor(Color.mycolor.mySecondary)
                        .frame(height: 24)
                }
            }
            
            // Даты месяца
            LazyVGrid(columns: columns, spacing: 8) {
                // Пустые ячейки для смещения
                ForEach(0..<viewModel.weekdayOffset(), id: \.self) { _ in
                    Color.clear
                        .frame(height: 32)
                }
                
                // Даты месяца
                ForEach(viewModel.datesInMonth(), id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        hasWorkout: !viewModel.workoutsForDay(date).isEmpty,
                        isCurrentMonth: viewModel.isCurrentMonth(date),
                        viewModel: viewModel
                    )
                    .onTapGesture {
                        viewModel.selectDate(date)
                    }
                }
            }
        }
    }
}

#Preview {
    class PreviewCalendarViewModel: CalendarViewModel {
        // Всегда показывать ноябрь 2025
        override var currentDate: Date {
            get {
                // Фиксируем ноябрь 2025 для превью
                Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 1))!
            }
            set {
                // Игнорируем установку новой даты в превью
            }
        }
        
        // Переопределяем чтобы всегда было 5 пустых ячеек (для ноября 2025, который начинается с пятницы)
        override func weekdayOffset() -> Int {
            return 5 // Ноябрь 2025 начинается с пятницы
        }
        
        // Переопределяем hasWorkouts для дней 21-25
        override func hasWorkoutsOnDay(_ date: Date) -> Bool {
            let day = Calendar.current.component(.day, from: date)
            return (21...25).contains(day)
        }
        
        // Переопределяем типы тренировок
        override func workoutTypesForDay(_ date: Date) -> [WorkoutActivityType] {
            let day = Calendar.current.component(.day, from: date)
            
            switch day {
            case 21:
                return [.walkingRunning, .cycling, .strength]
            case 22:
                return [.yoga, .water]
            case 23:
                return [.cycling]
            case 24:
                return [.strength, .walkingRunning]
            case 25:
                return [.water, .yoga, .cycling]
            default:
                return []
            }
        }
        
        // Всегда текущий месяц
        override func isCurrentMonth(_ date: Date) -> Bool {
            return true
        }
        
        // Дата сегодня - 15 ноября для теста
        override func isToday(_ date: Date) -> Bool {
            let day = Calendar.current.component(.day, from: date)
            return day == 15
        }
    }
    
    return CalendarGridView(viewModel: PreviewCalendarViewModel(
        apiService: MockDataService(),
        initialDate: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 1))!
    ))
    .padding()
    .background(Color(.systemBackground))
    .environmentObject(AppCoordinator())
}
