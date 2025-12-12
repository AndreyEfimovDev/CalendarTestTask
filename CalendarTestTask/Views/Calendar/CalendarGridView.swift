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
                        .foregroundColor(.secondary)
                        .frame(height: 24)
                }
            }
            
            // Даты месяца
            LazyVGrid(columns: columns, spacing: 8) {
                // Пустые ячейки для смещения
                ForEach(0..<viewModel.weekdayOffset(), id: \.self) { _ in
                    Color.clear
                        .frame(height: 44)
                }
                
                // Даты месяца
                ForEach(viewModel.datesInMonth(), id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        viewModel: viewModel,
                        isCurrentMonth: viewModel.isCurrentMonth(date)
                    )
                    .onTapGesture {
                        viewModel.selectDay(date)
                    }
                }
            }
        }
    }
}

#Preview {
//    CalendarGridView()
}
