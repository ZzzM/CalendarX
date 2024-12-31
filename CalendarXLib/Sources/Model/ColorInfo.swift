//
//  ColorInfo.swift
//
//
//  Created by zm on 2024/5/30.
//

import Foundation

@MainActor
public struct ColorInfo: Codable, Hashable {
    public let hex: String
    private let name_en, name_zh: String
    public func name(from locale: Locale) -> String { locale.inChinese ? name_zh : name_en }
}

