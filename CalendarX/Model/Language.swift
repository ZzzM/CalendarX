//
//  Language.swift
//  CalendarX
//
//  Created by zm on 2022/1/18.
//

import SwiftUI

enum Language: Int, CaseIterable {
    
    case system, zh_CN, en_US
    
    var locale: Locale {
        switch self {
        case .zh_CN: return .zh
        case .en_US: return .en
        default: return Locale.current
        }
    }
    
    var title: LocalizedStringKey {
        switch self {
        case .zh_CN: return L10n.Language.zh_CN
        case .en_US: return L10n.Language.en_US
        default: return L10n.Language.system
        }
    }
    
}


