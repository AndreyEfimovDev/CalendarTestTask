//
//  CalendarHeader.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import SwiftUI

struct CalendarHeader: View {
    let monthYear: String
    let onPrevious: () -> Void
    let onNext: () -> Void
    let onToday: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: onPrevious) {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .foregroundColor(Color.mycolor.myBlue)
                    .frame(width: 44, height: 44) // Фиксированный размер
            }
            
            HStack(spacing: 16) {
                Text(monthYear)
                    .font(.headline)
                    .foregroundColor(Color.mycolor.myAccent)
                    .frame(maxWidth: .infinity)

            }
            .padding(.horizontal, 8)
            
            Button(action: onNext) {
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundColor(Color.mycolor.myBlue)
                    .frame(width: 44, height: 44) // Фиксированный размер
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 44)
    }
}

#Preview {
    CalendarHeader(
        monthYear: "Ноябрь 2025",
        onPrevious: {
            print("Нажата кнопка назад")
        },
        onNext: {
            print("Нажата кнопка вперед")
        },
        onToday: {
            print("Нажата кнопка Сегодня")
        }
    )
    .padding()
    .background(Color.gray.opacity(0.05))
}
