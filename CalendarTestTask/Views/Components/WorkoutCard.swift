//
//  WorkoutCard.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 15.12.2025.
//

import SwiftUI

struct WorkoutCard: View {
    
    let workout: Workout
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: workout.workoutActivityType.icon)
                .font(.title2)
                .foregroundColor(workout.workoutActivityType.color)
                .frame(width: 40, height: 40)
                .background(workout.workoutActivityType.color.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.workoutActivityType.localizedName)
                    .font(.headline)
                    .foregroundColor(Color.mycolor.myAccent)
                
                Text(workout.timeString)
                    .font(.subheadline)
                    .foregroundColor(Color.mycolor.mySecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Color.mycolor.mySecondary)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}


#Preview {
//    WorkoutCard(workout: <#Workout#>)
}
