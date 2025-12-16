//
//  HeartRateChartView.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import SwiftUI
import Charts

struct HeartRateChartView: View {
    let diagramData: [DiagramData]
    
    private var chartData: [HeartRatePoint] {
        diagramData.map { data in
            HeartRatePoint(
                time: data.timeNumeric,
                heartRate: data.heartRate,
                speed: data.speedKmh
            )
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("График пульса")
                .font(.headline)
                .foregroundColor(Color.mycolor.myAccent)
            
            Chart(chartData) { point in
                LineMark(
                    x: .value("Время", point.time),
                    y: .value("Пульс", point.heartRate)
                )
                .foregroundStyle(Color.mycolor.myRed)
                
                PointMark(
                    x: .value("Время", point.time),
                    y: .value("Пульс", point.heartRate)
                )
                .foregroundStyle(Color.mycolor.myRed)
                .symbolSize(50)
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(position: .bottom)
            }
        }
        .padding()
        .background(Color.mycolor.mySecondary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct HeartRatePoint: Identifiable {
    let id = UUID()
    let time: Int
    let heartRate: Int
    let speed: Double
}


// MARK: - Preview
#Preview("График пульса - тестовые данные", traits: .sizeThatFitsLayout) {

    var testData: [DiagramData] = []
    
    for i in 0..<20 {
        let heartRate = 70 + Int.random(in: 0...30) + (i < 10 ? i * 3 : (20 - i) * 2)
        testData.append(
            DiagramData(
                timeNumeric: i,
                heartRate: heartRate,
                speedKmh: Double.random(in: 0...12),
                distanceMeters: i * 100,
                steps: i * 80,
                elevation: 45.0 + Double(i) * 0.3,
                latitude: 55.7558,
                longitude: 37.6173,
                temperatureCelsius: 12.5,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: Date()
            )
        )
    }
    
    return HeartRateChartView(diagramData: testData)
        .padding()
}

#Preview("График пульса - реальные данные (бег)", traits: .sizeThatFitsLayout) {

    let runningData = [
        DiagramData(
            timeNumeric: 0, heartRate: 72, speedKmh: 0.0,
            distanceMeters: 0, steps: 0, elevation: 45.2,
            latitude: 55.7558, longitude: 37.6173, temperatureCelsius: 12.5,
            currentLayer: 0, currentSubLayer: 0, currentTimestamp: Date()
        ),
        DiagramData(
            timeNumeric: 1, heartRate: 85, speedKmh: 6.2,
            distanceMeters: 103, steps: 120, elevation: 45.5,
            latitude: 55.7562, longitude: 37.6180, temperatureCelsius: 12.5,
            currentLayer: 0, currentSubLayer: 0, currentTimestamp: Date()
        ),
        DiagramData(
            timeNumeric: 2, heartRate: 92, speedKmh: 7.8,
            distanceMeters: 233, steps: 265, elevation: 46.1,
            latitude: 55.7568, longitude: 37.6189, temperatureCelsius: 12.4,
            currentLayer: 0, currentSubLayer: 1, currentTimestamp: Date()
        ),
        DiagramData(
            timeNumeric: 3, heartRate: 98, speedKmh: 8.4,
            distanceMeters: 373, steps: 420, elevation: 46.8,
            latitude: 55.7575, longitude: 37.6198, temperatureCelsius: 12.4,
            currentLayer: 0, currentSubLayer: 1, currentTimestamp: Date()
        ),
        DiagramData(
            timeNumeric: 4, heartRate: 105, speedKmh: 9.1,
            distanceMeters: 525, steps: 590, elevation: 47.2,
            latitude: 55.7583, longitude: 37.6210, temperatureCelsius: 12.3,
            currentLayer: 0, currentSubLayer: 2, currentTimestamp: Date()
        ),
        DiagramData(
            timeNumeric: 5, heartRate: 112, speedKmh: 9.5,
            distanceMeters: 683, steps: 768, elevation: 47.5,
            latitude: 55.7592, longitude: 37.6222, temperatureCelsius: 12.3,
            currentLayer: 0, currentSubLayer: 2, currentTimestamp: Date()
        ),
        DiagramData(
            timeNumeric: 6, heartRate: 118, speedKmh: 9.8,
            distanceMeters: 846, steps: 952, elevation: 48.0,
            latitude: 55.7601, longitude: 37.6235, temperatureCelsius: 12.2,
            currentLayer: 1, currentSubLayer: 0, currentTimestamp: Date()
        ),
        DiagramData(
            timeNumeric: 7, heartRate: 122, speedKmh: 10.2,
            distanceMeters: 1016, steps: 1145, elevation: 48.3,
            latitude: 55.7611, longitude: 37.6248, temperatureCelsius: 12.2,
            currentLayer: 1, currentSubLayer: 0, currentTimestamp: Date()
        ),
        DiagramData(
            timeNumeric: 8, heartRate: 128, speedKmh: 10.5,
            distanceMeters: 1191, steps: 1342, elevation: 48.8,
            latitude: 55.7621, longitude: 37.6262, temperatureCelsius: 12.1,
            currentLayer: 1, currentSubLayer: 1, currentTimestamp: Date()
        )
    ]
    
    return HeartRateChartView(diagramData: runningData)
        .padding()
}

#Preview("График пульса - велосипед", traits: .sizeThatFitsLayout) {
    var cyclingData: [DiagramData] = []
    
    for i in 0..<15 {
        let heartRate = 80 + Int.random(in: 0...40) + (i < 8 ? i * 4 : (15 - i) * 3)
        cyclingData.append(
            DiagramData(
                timeNumeric: i,
                heartRate: heartRate,
                speedKmh: Double.random(in: 15...35),
                distanceMeters: i * 300,
                steps: 0,
                elevation: 150.0 + Double(i) * 2.0,
                latitude: 55.6892,
                longitude: 37.5421,
                temperatureCelsius: 14.0,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: Date()
            )
        )
    }
    
    return HeartRateChartView(diagramData: cyclingData)
        .padding()
}

#Preview("График пульса - йога", traits: .sizeThatFitsLayout) {

    var yogaData: [DiagramData] = []
    
    for i in 0..<10 {
        let heartRate = 65 + Int.random(in: 0...15)
        yogaData.append(
            DiagramData(
                timeNumeric: i * 5, // Каждые 5 минут
                heartRate: heartRate,
                speedKmh: 0.0,
                distanceMeters: 0,
                steps: 0,
                elevation: 45.0,
                latitude: 55.7558,
                longitude: 37.6173,
                temperatureCelsius: 22.0,
                currentLayer: 0,
                currentSubLayer: i,
                currentTimestamp: Date()
            )
        )
    }
    
    return HeartRateChartView(diagramData: yogaData)
        .padding()
}

#Preview("График в WorkoutDetailView") {

    let apiService = MockDataService()
    let workout = Workout(
        id: "7823456789012345",
        workoutActivityType: .walkingRunning,
        workoutStartDate: Date()
    )
    let viewModel = WorkoutDetailViewModel(workout: workout, apiService: apiService)
    
    var testDiagramData: [DiagramData] = []
    for i in 0..<15 {
        testDiagramData.append(
            DiagramData(
                timeNumeric: i,
                heartRate: 75 + i * 3,
                speedKmh: Double(i) * 1.5,
                distanceMeters: i * 120,
                steps: i * 90,
                elevation: 45.0 + Double(i) * 0.2,
                latitude: 55.7558,
                longitude: 37.6173,
                temperatureCelsius: 12.5,
                currentLayer: i < 5 ? 0 : 1,
                currentSubLayer: i % 3,
                currentTimestamp: Date().addingTimeInterval(TimeInterval(i * 60))
            )
        )
    }
    

    return NavigationStack {
        WorkoutDetailView(viewModel: viewModel)
    }
}

#Preview("График пульса - фиксированный размер", traits: .fixedLayout(width: 400, height: 300)) {
    var fixedData: [DiagramData] = []
    
    for i in 0..<10 {
        fixedData.append(
            DiagramData(
                timeNumeric: i,
                heartRate: 70 + i * 5,
                speedKmh: Double(i) * 2.0,
                distanceMeters: i * 150,
                steps: i * 100,
                elevation: 50.0,
                latitude: 55.7558,
                longitude: 37.6173,
                temperatureCelsius: 20.0,
                currentLayer: 0,
                currentSubLayer: 0,
                currentTimestamp: Date()
            )
        )
    }
    
    return HeartRateChartView(diagramData: fixedData)
        .padding()
}
