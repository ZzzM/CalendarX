//
//  Bundle+.swift
//  CalendarX
//
//  Created by zm on 2022/2/21.
//

import Foundation

extension Bundle {
    static func decode<T: Decodable>(from resource: String, empty: T) -> T {
        guard let url = Self.module.url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let result = try? JSONDecoder().decode(T.self, from: data) else {
            return empty
        }
        return result
    }
}
