//
//  Appearance.swift
//  CalendarX
//
//  Created by zm on 2024/12/30.
//

import CalendarXLib
import SwiftUI

@MainActor
struct Appearance: @preconcurrency Codable {
    public var lightAccent, lightBackground, darkAccent, darkBackground: ColorInfo

    static let `default`: Self = .init()

    init() {
        lightAccent = Bundle.defaultLightAccent
        lightBackground = Bundle.defaultLightBackground
        darkAccent = Bundle.defaultDarkAccent
        darkBackground = Bundle.defaultDarkBackground
    }

    enum CodingKeys: String, CodingKey { case lightAccent, lightBackground, darkAccent, darkBackground }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lightAccent = try values.decode(ColorInfo.self, forKey: .lightAccent)
        lightBackground = try values.decode(ColorInfo.self, forKey: .lightBackground)
        darkAccent = try values.decode(ColorInfo.self, forKey: .darkAccent)
        darkBackground = try values.decode(ColorInfo.self, forKey: .darkBackground)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lightAccent, forKey: .lightAccent)
        try container.encode(lightBackground, forKey: .lightBackground)
        try container.encode(darkAccent, forKey: .darkAccent)
        try container.encode(darkBackground, forKey: .darkBackground)
    }
}

extension Appearance {
    public var accentColor: Color { .init(light: lightAccent.hex, dark: darkAccent.hex) }
    public var backgroundColor: Color { .init(light: lightBackground.hex, dark: darkBackground.hex) }
}

extension Appearance: @preconcurrency RawRepresentable {
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self), let result = String(data: data, encoding: .utf8) else { return "[]" }
        return result
    }

    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8), let result = try? JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        self = result
    }
}
