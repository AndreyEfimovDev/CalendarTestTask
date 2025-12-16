//
//  CalendarDayView.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import SwiftUI

struct CalendarDayView: View {
    let date: Date
    let hasWorkout: Bool
    let isCurrentMonth: Bool
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @ObservedObject var viewModel: CalendarViewModel

    private var dayNumber: Int {
        Calendar.current.component(.day, from: date)
    }
    
    private var isToday: Bool {
        viewModel.isToday(date)
    }
    
    private var isSelected: Bool {
        if let selectedDate = viewModel.selectedDate {
            return Calendar.current.isDate(date, inSameDayAs: selectedDate)
        } else {
            // Если нет выбранной даты, проверяем, является ли эта дата сегодняшней
            return Calendar.current.isDate(date, inSameDayAs: coordinator.initialCalendarDate)
        }
    }
    
    private var hasWorkouts: Bool {
        viewModel.hasWorkoutsOnDay(date)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(dayNumber)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(textColor)
                .frame(width: 30, height: 30)
                .background(circleBackground)
                .clipShape(Circle())
        }
        .frame(height: 30)
        .opacity(isCurrentMonth ? 1.0 : 0.4)
        .cornerRadius(8)
    }
    
    private var textColor: Color {
        if isSelected {
            return Color.mycolor.myButtonTextPrimary
        } else if isToday {
            return Color.mycolor.myBlue
        } else {
            return isCurrentMonth ? Color.mycolor.myAccent : Color.mycolor.mySecondary
        }
    }
    
    private var circleBackground: Color {
        if isSelected {
            return Color.mycolor.myBlue
        } else if isToday {
            return Color.mycolor.myBlue.opacity(0.1)
        } else if hasWorkouts {
            return Color.mycolor.myGreen.opacity(0.3)
        } else {
            return .clear
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        Group {
            Text("День с 3 тренировками")
                .font(.headline)
                .foregroundColor(.secondary)
            
            CalendarDayView(
                date: createDate(day: 21), hasWorkout: true,
                isCurrentMonth: true, viewModel: createMockViewModel(hasWorkouts: true, workoutCount: 3)
            )
        }
        
        Group {
            Text("День с 1 тренировкой")
                .font(.headline)
                .foregroundColor(Color.mycolor.mySecondary)
            
            CalendarDayView(
                date: createDate(day: 22), hasWorkout: true,
                isCurrentMonth: true, viewModel: createMockViewModel(hasWorkouts: true, workoutCount: 1)
            )
        }
        
        Group {
            Text("День без тренировок")
                .font(.headline)
                .foregroundColor(Color.mycolor.mySecondary)
            
            CalendarDayView(
                date: createDate(day: 23), hasWorkout: false,
                isCurrentMonth: true, viewModel: createMockViewModel(hasWorkouts: false)
            )
        }
        
        Group {
            Text("Сегодня с 2 тренировками")
                .font(.headline)
                .foregroundColor(Color.mycolor.mySecondary)
            
            CalendarDayView(
                date: Date(), hasWorkout: false,
                isCurrentMonth: true, viewModel: createMockViewModel(hasWorkouts: true, workoutCount: 2)
            )
        }
    }
    .padding()
    .background(Color(.systemBackground))
    .environmentObject(AppCoordinator())
}

// Вспомогательные функции
private func createDate(day: Int) -> Date {
    Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: day))!
}

// Класс для мок-данных в превью
private class PreviewCalendarViewModel: CalendarViewModel {
    private let previewHasWorkouts: Bool
    private let previewWorkoutCount: Int
    
    init(hasWorkouts: Bool, workoutCount: Int = 3) {
        self.previewHasWorkouts = hasWorkouts
        self.previewWorkoutCount = workoutCount
        super.init(apiService: MockDataService(), initialDate: Date())
    }
    
    override func hasWorkoutsOnDay(_ date: Date) -> Bool {
        return previewHasWorkouts
    }
    
    override func workoutTypesForDay(_ date: Date) -> [WorkoutActivityType] {
        guard previewHasWorkouts else { return [] }
        
        let allTypes: [WorkoutActivityType] = [
            .walkingRunning,
            .cycling,
            .strength,
            .yoga,
            .water
        ]
        
        return Array(allTypes.prefix(previewWorkoutCount))
    }
    
    override func isToday(_ date: Date) -> Bool {
        return Calendar.current.isDateInToday(date)
    }
    
    // Всегда показывать как текущий месяц
    override func isCurrentMonth(_ date: Date) -> Bool {
        return true
    }
}

private func createMockViewModel(hasWorkouts: Bool, workoutCount: Int = 3) -> CalendarViewModel {
    PreviewCalendarViewModel(hasWorkouts: hasWorkouts, workoutCount: workoutCount)
}


#Preview("CalendarDayView Preview") {
    let dates = [21, 22, 23, 24]
    
    return HStack(spacing: 15) {
        ForEach(dates, id: \.self) { day in
            VStack(spacing: 4) {
                Text("\(day)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(width: 32, height: 32)
                    .background(day == 21 ? Color.blue.opacity(0.1) : Color.clear)
                    .clipShape(Circle())
                
                if day == 21 || day == 24 { // Дни с тренировками
                    HStack(spacing: 3) {
                        // Точки с цветами из WorkoutActivityType
                        Circle().fill(Color.blue).frame(width: 6, height: 6)    // walkingRunning
                        Circle().fill(Color.green).frame(width: 6, height: 6)   // cycling
                        Circle().fill(Color.orange).frame(width: 6, height: 6)  // strength
                    }
                    .padding(.top, 2)
                }
            }
            .frame(height: 56)
            .opacity(day == 23 ? 0.4 : 1.0) // 23 число - не из текущего месяца
        }
    }
    .padding()
    .background(Color(.systemBackground))
    .environmentObject(AppCoordinator())
}
