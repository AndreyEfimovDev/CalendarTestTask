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
            // Кнопка назад
            Button(action: onPrevious) {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .foregroundColor(Color.mycolor.myBlue)
                    .frame(width: 44, height: 44) // Фиксированный размер
            }
            
            // Центральная часть с датой и кнопкой "Сегодня"
            HStack(spacing: 16) {
                Text(monthYear)
                    .font(.headline)
                    .foregroundColor(Color.mycolor.myAccent)
                    .frame(maxWidth: .infinity)
                
//                Button(action: onToday) {
//                    Text("Ноябрь")
//                        .font(.subheadline)
//                        .foregroundColor(.blue)
//                        .padding(.horizontal, 12)
//                        .padding(.vertical, 6)
//                        .background(Color.blue.opacity(0.1))
//                        .cornerRadius(8)
//                }
//                .fixedSize() // Не дает кнопке сжиматься
                
            }
            .padding(.horizontal, 8)
            
            // Кнопка вперед
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
//    CalendarHeader()
}

//
//GeometryReader { geometry in
//            HStack {
//                Button(action: onPrevious) {
//                    Image(systemName: "chevron.left")
//                }
//                
//                Spacer(minLength: 8)
//                
//                // Адаптивный текст
//                if geometry.size.width > 350 {
//                    // Для широких экранов - полный вид
//                    HStack {
//                        Text(monthYear)
//                        Button("Сегодня", action: onToday)
//                    }
//                } else {
//                    // Для узких экранов - компактный вид
//                    VStack(alignment: .center, spacing: 4) {
//                        Text(monthYear)
//                            .font(.headline)
//                        Button("Сегодня", action: onToday)
//                            .font(.caption)
//                    }
//                }
//                
//                Spacer(minLength: 8)
//                
//                Button(action: onNext) {
//                    Image(systemName: "chevron.right")
//                }
//            }
//            .padding(.horizontal)
//        }
//        .frame(height: 60)
