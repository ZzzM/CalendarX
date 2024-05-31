//
//  ColorInfo.swift
//
//
//  Created by zm on 2024/5/30.
//

import Foundation

public struct ColorInfo: Codable, Hashable {
    public let hex: String
    private let name_en, name_zh: String
    public var name: String {
        L10n.inChinese ? name_zh: name_en
    }
    public func name(from locale: Locale) -> String {
        locale.inChinese ? name_zh: name_en
    }
}
