//
//  CodableHelpers.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 12.12.2025.
//

import Foundation

@propertyWrapper
struct DoubleOrString: Codable {
    var wrappedValue: Double
    
    init(wrappedValue: Double) {
        self.wrappedValue = wrappedValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        do {
            wrappedValue = try container.decode(Double.self)
        } catch {
            let stringValue = try container.decode(String.self)
            if let doubleValue = Double(stringValue) {
                wrappedValue = doubleValue
            } else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Не могу преобразовать '\(stringValue)' в Double"
                )
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
