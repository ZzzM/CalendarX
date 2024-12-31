//
//  Language.swift
//  CalendarXLib
//
//  Created by zm on 2024/12/30.
//
import SwiftUI

@MainActor
public enum Language: Int, CaseIterable {
    case system, zh_CN, en_US

    public var locale: Locale {
        switch self {
        case .zh_CN: .zh
        case .en_US: .en
        default: .current
        }
    }

    public var title: LocalizedStringKey {
        switch self {
        case .zh_CN: L10n.Language.zh_CN
        case .en_US: L10n.Language.en_US
        default: L10n.Language.system
        }
    }
}
