//
//  Bundle+.swift
//  CalendarX
//
//  Created by zm on 2022/2/21.
//

import Foundation

public extension Bundle {
    func json2KeyValue<T: Decodable>(from resource: String) -> [String: T] {
        guard let url = url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let dict = try? JSONDecoder().decode([String: T].self, from: data) else {
            return [:]
        }
        return dict
    }
    func json2Object<T: Decodable>(from resource: String) -> T? {
        guard let url = url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let object = try? JSONDecoder().decode(T.self, from: data) else {
            return .none
        }
        return object
    }
    
    func json2Festival(from resource: String) -> [String: String] {
        json2KeyValue(from: resource)
    }
    func json2AllFestivals(from resource: String) -> [String: [String]] {
        json2KeyValue(from: resource)
    }

}
