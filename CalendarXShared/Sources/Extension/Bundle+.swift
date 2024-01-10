//
//  Bundle+.swift
//  CalendarX
//
//  Created by zm on 2022/2/21.
//

import Foundation

protocol Formatable {
    associatedtype Response: Decodable
    static var empty: Response { get }
}

extension Formatable {
    static func json2Object(from resource: String) -> Response {
        guard let url = Bundle.module.url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let object = try? JSONDecoder().decode(Response.self, from: data) else {
            return empty
        }
        return object
    }
}

public struct PatternA: Formatable {
    public typealias Response = [AppInfo]
    static var empty: Response { [] }
}

struct PatternB: Formatable {
    typealias Response = [String: [String: AppDateState]]
    static var empty: Response { [:] }
}

struct PatternC: Formatable {
    typealias Response = [String: [String]]
    static var empty: Response { [:] }
}

struct PatternD: Formatable {
    typealias Response = [String: String]
    static var empty: Response { [:] }
}


