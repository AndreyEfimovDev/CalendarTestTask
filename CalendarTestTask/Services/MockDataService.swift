//
//  MockDataService.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import Foundation

class MockDataService: APIServiceProtocol {
    private let decoder: JSONDecoder
    
    init() {
        self.decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            let formatters = [
                "yyyy-MM-dd HH:mm:ss",
                "yyyy-MM-dd",
                "yyyy/MM/dd HH:mm:ss",
                "yyyy/MM/dd"
            ]
            
            for format in formatters {
                let formatter = DateFormatter()
                formatter.dateFormat = format
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                
                if let date = formatter.date(from: dateString) {
                    return date
                }
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Невозможно декодировать дату: \(dateString)"
            )
        }
        
        testMetadataDecoding()
    }
    
    // MARK: - APIServiceProtocol
    
    func fetchWorkouts() async throws -> [Workout] {
        guard let url = Bundle.main.url(forResource: "list_workouts", withExtension: "json") else {
            throw APIError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            let response = try decoder.decode(ListWorkoutsResponse.self, from: data)
            return response.data.map { item in
                Workout(
                    id: item.workoutKey,
                    workoutActivityType: item.workoutActivityType,
                    workoutStartDate: item.workoutStartDate
                )
            }
        } catch {
            throw APIError.decodingError
        }
    }
    
    func fetchWorkouts(for date: Date) async throws -> [Workout] {
        // Фильтруем тренировки по дате
        let allWorkouts = try await fetchWorkouts()
        return allWorkouts.filter { workout in
            Calendar.current.isDate(workout.date, inSameDayAs: date)
        }
    }
    
    func fetchMetadata(for workoutId: String) async throws -> WorkoutMetadata? {
        guard let url = Bundle.main.url(forResource: "metadata", withExtension: "json") else {
            print("❌ Файл metadata.json не найден")
            throw APIError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            print("✅ Файл metadata.json загружен, размер: \(data.count) байт")
            
            // Пробуем декодировать
            let response = try decoder.decode(MetadataResponse.self, from: data)
            
            if let metadata = response.workouts[workoutId] {
                print("🎉 Метаданные успешно декодированы для \(workoutId)")
                print("   - Дистанция: \(metadata.distance) (\(metadata.formattedDistance))")
                print("   - Длительность: \(metadata.duration) (\(metadata.formattedDuration))")
                print("   - Температура: \(metadata.avgTemp)°C")
                print("   - Влажность: \(metadata.avgHumidity)%")
                return metadata
            } else {
                print("⚠️ Тренировка \(workoutId) не найдена в metadata.json")
                return nil
            }
            
        } catch let decodingError as DecodingError {
            print("❌ Ошибка декодирования metadata:")
            print("   - Тип ошибки: \(decodingError)")
            
            // Подробности ошибки
            switch decodingError {
            case .keyNotFound(let key, let context):
                print("   - Ключ не найден: \(key.stringValue)")
                print("   - Контекст: \(context.debugDescription)")
            case .typeMismatch(let type, let context):
                print("   - Несовпадение типа: \(type)")
                print("   - Контекст: \(context.debugDescription)")
            case .valueNotFound(let type, let context):
                print("   - Значение не найдено: \(type)")
                print("   - Контекст: \(context.debugDescription)")
            case .dataCorrupted(let context):
                print("   - Данные повреждены")
                print("   - Контекст: \(context.debugDescription)")
            @unknown default:
                print("   - Неизвестная ошибка декодирования")
            }
            
            throw APIError.decodingError
        } catch {
            print("❌ Неизвестная ошибка: \(error)")
            throw APIError.decodingError
        }
    }

    func fetchDiagramData(for workoutId: String) async throws -> [DiagramData]? {
        guard let url = Bundle.main.url(forResource: "diagram_data", withExtension: "json") else {
            print("❌ Файл diagram_data.json не найден")
            throw APIError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            let response = try decoder.decode(DiagramDataResponse.self, from: data)
            
            if let workoutData = response.workouts[workoutId] {
                print("✅ Данные графика для \(workoutId): \(workoutData.data.count) точек")
                return workoutData.data
            } else {
                print("⚠️ Данные графика для \(workoutId) не найдены")
                return nil
            }
        } catch {
            print("❌ Ошибка загрузки данных графика: \(error)")
            throw APIError.decodingError
        }
    }
    
    func testMetadataDecoding() {
        print("🧪 Тестируем декодирование metadata.json...")
        
        guard let url = Bundle.main.url(forResource: "metadata", withExtension: "json") else {
            print("❌ Файл metadata.json не найден")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            print("✅ Файл найден, размер: \(data.count) байт")
            
            // Пробуем прочитать как raw JSON
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                print("✅ JSON успешно прочитан")
                
                if let workouts = json["workouts"] as? [String: Any] {
                    print("✅ Найдено тренировок: \(workouts.count)")
                    
                    if let firstWorkout = workouts["7823456789012345"] as? [String: Any] {
                        print("\n🔍 Анализ первой тренировки:")
                        
                        for (key, value) in firstWorkout {
                            let type = type(of: value)
                            print("   - \(key): \(type) = \(value)")
                        }
                        
                        // Проверяем проблемные поля
                        print("\n🔍 Проверка числовых полей:")
                        if let distance = firstWorkout["distance"] {
                            print("   distance: тип = \(type(of: distance)), значение = \(distance)")
                        }
                        if let duration = firstWorkout["duration"] {
                            print("   duration: тип = \(type(of: duration)), значение = \(duration)")
                        }
                    }
                }
            }
            
            print("\n🧪 Пробуем декодировать через JSONDecoder...")
            let response = try decoder.decode(MetadataResponse.self, from: data)
            print("✅ Успешно декодировано через JSONDecoder")
            
            if let metadata = response.workouts["7823456789012345"] {
                print("🎉 Метаданные получены!")
                print("   Дистанция: \(metadata.distance)")
                print("   Длительность: \(metadata.duration)")
            }
            
        } catch let error as DecodingError {
            print("❌ Ошибка декодирования:")
            print("   \(error)")
        } catch {
            print("❌ Неизвестная ошибка: \(error)")
        }
    }

}

// MARK: - Вспомогательные структуры для декодирования

struct ListWorkoutsResponse: Codable {
    let description: String
    let data: [WorkoutItem]
}

struct WorkoutItem: Codable {
    let workoutKey: String
    let workoutActivityType: WorkoutActivityType
    let workoutStartDate: Date
}

struct MetadataResponse: Codable {
    let description: String
    let workouts: [String: WorkoutMetadata]
}

struct DiagramDataResponse: Codable {
    let description: String
    let workouts: [String: WorkoutDiagramData]
}

struct WorkoutDiagramData: Codable {
    let description: String
    let data: [DiagramData]
    let states: [String]
}



