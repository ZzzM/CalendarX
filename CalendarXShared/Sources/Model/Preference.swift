//
//  Preferences.swift
//  Bingpaper
//
//  Created by zm on 2021/10/26.
//
import SwiftUI

public struct Preference {

    public static let shared = Preference()

    @AppStorage(AppStorageKey.theme, store: .group)
    public var theme: Theme = .system

    @AppStorage(AppStorageKey.appearance, store: .group)
    public var appearance: Appearance = .default

    @AppStorage(AppStorageKey.language, store: .group)
    public var language: Language = .system

}

public extension Preference {
    var accentColor: Color { appearance.accentColor }
    var backgroundColor: Color { appearance.backgroundColor }

    var colorScheme: ColorScheme? { theme.colorScheme }
    var locale: Locale { language.locale }
}


public enum Theme: Int, CaseIterable {

    case system, light, dark

    public var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        default: return .none
        }
    }

    public var title: LocalizedStringKey {
        switch self {
        case .light: return L10n.Theme.light
        case .dark: return L10n.Theme.dark
        default: return L10n.Theme.system
        }
    }

}

public enum Language: Int, CaseIterable {

    case system, zh_CN, en_US

    public var locale: Locale {
        switch self {
        case .zh_CN: return .zh
        case .en_US: return .en
        default: return .current
        }
    }

    public var title: LocalizedStringKey {
        switch self {
        case .zh_CN: return L10n.Language.zh_CN
        case .en_US: return L10n.Language.en_US
        default: return L10n.Language.system
        }
    }

}

public struct Appearance: Codable {

    public var lightAccent, lightBackground,
               darkAccent, darkBackground: ColorInfo

    static let `default`: Self = .init()

    init() {
        self.lightAccent = Bundle.defaultLightAccent
        self.lightBackground = Bundle.defaultLightBackground
        self.darkAccent = Bundle.defaultDarkAccent
        self.darkBackground = Bundle.defaultDarkBackground
    }

    enum CodingKeys: String, CodingKey {
        case lightAccent, lightBackground,
             darkAccent, darkBackground
    }

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


public extension Appearance {
    var accentColor: Color { .init(light: lightAccent.hex, dark: darkAccent.hex) }
    var backgroundColor: Color { .init(light: lightBackground.hex, dark: darkBackground.hex) }
}

extension Appearance {
    public static let lightAccentColors = [
        "FFA07A", "FF7F50", "FF6347", "FF4500", "FF0000", "DEB887", "D2691E", "CD853F", "A0522D", "8B4513",
        "00FF00", "32CD32", "3CB371", "228B22", "006400", "00BFFF", "1E90FF", "6495ED", "4169E1", "0000FF",
        "FFFF00", "FFF000", "FFEA00", "FDD017", "F4C430", "FFC04C", "FFB347", "FFAA33", "FFA500", "FF8C00",
        "DDA0DD", "DA70D6", "BA55D3", "8A2BE2", "6A0DAD","FFB6C1", "FF69B4", "FF1493", "DB7093", "C71585"
    ]

    public static let darkAccentColors = [
        "704F4F", "A77979", "E97777", "EE4540", "AA2B1D", "CC561E", "F07B3F", "AD8B73", "876445",
        "CA965C", "F1CA89", "847545", "E0C341", "A1B57D", "A4B494", "519872", "59CE8F", "03C988",
        "1F8A70", "007880", "00A8CC", "42C2FF", "A1CAE2", "2C74B3", "205295", "4A89DC", "1363DF",
        "6D67E4", "5B4B8A", "4C3575", "7858A6", "CD4DCC", "D770AD", "A61F69", "B25068", "C72C41"
    ]

    public static let lightBackgroundColors = [
        "F0F0F0", "F2F2F2",  "F4F4F4", "F5F5F5", "F8F8F8", "FAFAFA", "FCFCFC", "FEFEFE", "FFFAFA",
        "FFFFFF"
    ]

    public static let darkBackgroundColors = [
        "323232", "2C2C2C", "232323", "1D1C1C", "161616", "141010",  "0F0F0F", "0C0C0C", "0A0A0A",
        "000000"
    ]


}

extension Appearance: RawRepresentable {
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }

    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        self = result
    }
}

