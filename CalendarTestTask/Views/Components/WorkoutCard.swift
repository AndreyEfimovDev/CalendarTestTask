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

#Preview("WorkoutCard - Все типы") {
    VStack(spacing: 12) {
        WorkoutCard(workout: Workout(
            id: "1",
            workoutActivityType: .walkingRunning,
            workoutStartDate: Calendar.current.date(bySettingHour: 6, minute: 30, second: 0, of: Date())!
        ))
        
        WorkoutCard(workout: Workout(
            id: "2",
            workoutActivityType: .yoga,
            workoutStartDate: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
        ))
        
        WorkoutCard(workout: Workout(
            id: "3",
            workoutActivityType: .water,
            workoutStartDate: Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date())!
        ))
        
        WorkoutCard(workout: Workout(
            id: "4",
            workoutActivityType: .cycling,
            workoutStartDate: Calendar.current.date(bySettingHour: 15, minute: 30, second: 0, of: Date())!
        ))
        
        WorkoutCard(workout: Workout(
            id: "5",
            workoutActivityType: .strength,
            workoutStartDate: Calendar.current.date(bySettingHour: 18, minute: 45, second: 0, of: Date())!
        ))
    }
    .padding()
    .background(Color.gray.opacity(0.05))
}

#Preview("WorkoutCard - Разное время") {
    VStack(spacing: 8) {
        // Утро
        WorkoutCard(workout: Workout(
            id: "1",
            workoutActivityType: .walkingRunning,
            workoutStartDate: Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date())!
        ))
        
        // День
        WorkoutCard(workout: Workout(
            id: "2",
            workoutActivityType: .water,
            workoutStartDate: Calendar.current.date(bySettingHour: 12, minute: 30, second: 0, of: Date())!
        ))
        
        // Вечер
        WorkoutCard(workout: Workout(
            id: "3",
            workoutActivityType: .strength,
            workoutStartDate: Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: Date())!
        ))
        
        // Поздний вечер
        WorkoutCard(workout: Workout(
            id: "4",
            workoutActivityType: .yoga,
            workoutStartDate: Calendar.current.date(bySettingHour: 21, minute: 15, second: 0, of: Date())!
        ))
    }
    .padding()
    .background(Color.gray.opacity(0.05))
}

#Preview("WorkoutCard - Темная тема") {
    VStack(spacing: 12) {
        WorkoutCard(workout: Workout(
            id: "1",
            workoutActivityType: .cycling,
            workoutStartDate: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!
        ))
        
        WorkoutCard(workout: Workout(
            id: "2",
            workoutActivityType: .strength,
            workoutStartDate: Calendar.current.date(bySettingHour: 17, minute: 30, second: 0, of: Date())!
        ))
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}

#Preview("WorkoutCard - В списке") {
    List {
        Section("Утро") {
            WorkoutCard(workout: Workout(
                id: "1",
                workoutActivityType: .walkingRunning,
                workoutStartDate: Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: Date())!
            ))
            
            WorkoutCard(workout: Workout(
                id: "2",
                workoutActivityType: .yoga,
                workoutStartDate: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
            ))
        }
        
        Section("День") {
            WorkoutCard(workout: Workout(
                id: "3",
                workoutActivityType: .water,
                workoutStartDate: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
            ))
            
            WorkoutCard(workout: Workout(
                id: "4",
                workoutActivityType: .cycling,
                workoutStartDate: Calendar.current.date(bySettingHour: 15, minute: 45, second: 0, of: Date())!
            ))
        }
        
        Section("Вечер") {
            WorkoutCard(workout: Workout(
                id: "5",
                workoutActivityType: .strength,
                workoutStartDate: Calendar.current.date(bySettingHour: 18, minute: 30, second: 0, of: Date())!
            ))
        }
    }
    .listStyle(.insetGrouped)
}


