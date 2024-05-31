//
//  Color+.swift
//  CalendarX
//
//  Created by zm on 2022/4/25.
//

import SwiftUI

public extension Color {
    
    init(light: String, lightAlpha: CGFloat = 1,
         dark: String, darkAlpha: CGFloat = 1) {
        self.init(.init(name: .none, dynamicProvider: {
            $0.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua ?
                .init(hex: dark, alpha: darkAlpha):
                .init(hex: light,  alpha: lightAlpha)
        }))
    }
    
    init(hex: String, alpha: CGFloat = 1) {
        self.init(ns: .init(hex: hex, alpha: alpha))
    }
    
    init(ns color: NSColor) {
        if #available(macOS 12.0, *) {
            self.init(nsColor: color)
        } else {
            self.init(color)
        }
    }

    init(cg color: CGColor) {
        if #available(macOS 12.0, *) {
            self.init(cgColor: color)
        } else {
            self.init(color)
        }
    }

    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor?.components, components.count >= 3 else {
            return nil
        }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }

}


extension NSColor {

    convenience init(hex: Int, alpha: CGFloat = 1) {
        self.init(
            calibratedRed: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0xFF00) >> 8) / 255.0,
            blue: CGFloat((hex & 0xFF)) / 255.0,
            alpha: alpha
        )
    }

    convenience init(hex: String, alpha: CGFloat = 1) {
        var hexString = hex
        if hex.hasPrefix("0x") {
            hexString =   hex[hex.index(hexString.startIndex, offsetBy: 2)...] + ""
        } else if hex.hasPrefix("#") {
            hexString = hex[hex.index(hexString.startIndex, offsetBy: 1)...] + ""
        }

        let pattern = "[a-fA-F0-9]+"

        if NSPredicate(format:"SELF MATCHES %@", pattern).evaluate(with: hexString) {
            var value: UInt64 = 0
            Scanner(string: hexString).scanHexInt64(&value)
            self.init(hex: Int(value), alpha: alpha)
        } else {
            self.init(.black)
        }
    }
}
