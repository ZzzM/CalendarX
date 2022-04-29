//
//  Tint.swift
//  CalendarX
//
//  Created by zm on 2021/11/2.
//

import SwiftUI

struct Tint: Decodable {
    let name: String, light: String, dark: String
}
extension Tint {
    var asColor: Color { Color(light: light, dark: dark) }
}
extension Tint {
    private static let palette: [Tint] = Bundle.main.json2Object(from: "palette") ?? []
    static let allCases = Array(0..<palette.count)
    static subscript(index: Int) -> Color { palette[index].asColor }
}
