//
//  Language.swift
//  CalendarX
//
//  Created by zm on 2022/1/18.
//

import SwiftUI

enum Language: String, CaseIterable {
    case system, chinese, english
    
    var locale: Locale {
        switch self {
        case .chinese: return .zh
        case .english: return .en
        default: return .current
        }
    }

}


