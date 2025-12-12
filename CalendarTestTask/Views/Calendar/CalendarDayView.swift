//
//  CalendarDayView.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import SwiftUI

struct CalendarDayView: View {
    let date: Date
    let viewModel: CalendarViewModel
    let isCurrentMonth: Bool
    
    private var dayNumber: Int {
        Calendar.current.component(.day, from: date)
    }
    
    private var isToday: Bool {
        viewModel.isToday(date)
    }
    
    private var isSelected: Bool {
        Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate)
    }
    
    private var hasWorkouts: Bool {
        viewModel.hasWorkoutsOnDay(date)
    }
    
    private var workoutTypes: [WorkoutActivityType] {
        viewModel.workoutTypesForDay(date)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            // Число
            Text("\(dayNumber)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(textColor)
                .frame(width: 36, height: 36)
                .background(background)
                .clipShape(Circle())
            
            // Индикаторы тренировок
            if hasWorkouts {
                HStack(spacing: 2) {
                    ForEach(workoutTypes.prefix(3), id: \.self) { type in
                        Circle()
                            .fill(type.color)
                            .frame(width: 4, height: 4)
                    }
                }
                .frame(height: 4)
            }
        }
        .frame(height: 56)
        .opacity(isCurrentMonth ? 1.0 : 0.4)
    }
    
    private var textColor: Color {
        if isSelected {
            return .white
        } else if isToday {
            return .blue
        } else {
            return isCurrentMonth ? .primary : .secondary
        }
    }
    
    private var background: Color {
        if isSelected {
            return .blue
        } else if isToday {
            return Color.blue.opacity(0.1)
        } else {
            return .clear
        }
    }
}

#Preview {
//    CalendarDayView()
}
