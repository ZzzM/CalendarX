//
//  Color+.swift
//  CalendarX
//
//  Created by zm on 2022/4/25.
//

import SwiftUI

extension Color {
    init(light: String, dark: String) {
        self.init(.init(name: .none, dynamicProvider: {
            $0.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua ?
                .init(hex: dark):
                .init(hex: light)
        }))
    }
}


extension NSColor {

    convenience init(hex: Int, alpha: CGFloat) {
        self.init(
            calibratedRed: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0xFF00) >> 8) / 255.0,
            blue: CGFloat((hex & 0xFF)) / 255.0,
            alpha: 1.0
        )
    }

    convenience init(hex: String) {
        var hexString = hex
        if hex.hasPrefix("0x") {
            hexString = String(hex[hex.index(hexString.startIndex, offsetBy: 2)...hex.endIndex])
        } else if hex.hasPrefix("#") {
            hexString = String(hex[hex.index(hexString.startIndex, offsetBy: 1)...hex.endIndex])
        }

        let pattern = "[a-fA-F0-9]+"

        if NSPredicate(format:"SELF MATCHES %@", pattern).evaluate(with: hexString) {
            var value: UInt64 = 0
            Scanner(string: hexString).scanHexInt64(&value)
            self.init(hex: Int(value), alpha: 1)
        } else {
            fatalError("Unable to parse color?")
        }
    }
}
