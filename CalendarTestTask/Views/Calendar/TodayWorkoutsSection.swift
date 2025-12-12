//
//  TodayWorkoutsSection.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import SwiftUI

struct TodayWorkoutsSection: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Тренировки сегодня")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if viewModel.hasWorkoutsOnDay(Date()) {
                    Button("Все") {
                        viewModel.selectDay(Date())
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
            
            if viewModel.hasWorkoutsOnDay(Date()) {
                let todaysWorkouts = viewModel.workoutsForDay(Date())
                VStack(spacing: 8) {
                    ForEach(todaysWorkouts.prefix(3)) { workout in
                        WorkoutCard(workout: workout)
                    }
                    
                    if todaysWorkouts.count > 3 {
                        Text("и еще \(todaysWorkouts.count - 3) тренировок")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                Text("Сегодня нет тренировок")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}


#Preview {
//    TodayWorkoutsSection()
}
