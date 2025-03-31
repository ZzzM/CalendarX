//
//  Color+.swift
//  CalendarX
//
//  Created by zm on 2022/4/25.
//

import AppKit
import SwiftUI

extension Color {
    public init(lightHex: String, darkHex: String) {
        self.init(
            ns: .init(name: .none) {
                return switch $0.bestMatch(from: [.aqua, .darkAqua]) {
                case .darkAqua: .init(hex: darkHex) ?? .white
                default: .init(hex: lightHex) ?? .black
                }
            }
        )
    }

    public init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") { hexSanitized.removeFirst() }

        // Ensure valid length (3, 4, 6, or 8 characters)
        guard [3, 4, 6, 8].contains(hexSanitized.count) else { return nil }

        var hexValue: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&hexValue) else { return nil }

        let (r, g, b, a): (Double, Double, Double, Double)

        switch hexSanitized.count {
        case 3:  // RGB (e.g. F60)
            r = Double((hexValue >> 8) & 0xF) / 15.0
            g = Double((hexValue >> 4) & 0xF) / 15.0
            b = Double(hexValue & 0xF) / 15.0
            a = 1.0
        case 4:  // ARGB (e.g. FFF0)
            a = Double((hexValue >> 12) & 0xF) / 15.0
            r = Double((hexValue >> 8) & 0xF) / 15.0
            g = Double((hexValue >> 4) & 0xF) / 15.0
            b = Double(hexValue & 0xF) / 15.0
        case 6:  // RRGGBB (e.g. FF6600)
            r = Double((hexValue >> 16) & 0xFF) / 255.0
            g = Double((hexValue >> 8) & 0xFF) / 255.0
            b = Double(hexValue & 0xFF) / 255.0
            a = 1.0
        case 8:  // AARRGGBB (e.g. FFFF6600)
            a = Double((hexValue >> 24) & 0xFF) / 255.0
            r = Double((hexValue >> 16) & 0xFF) / 255.0
            g = Double((hexValue >> 8) & 0xFF) / 255.0
            b = Double(hexValue & 0xFF) / 255.0
        default:
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }

    public init(ns color: NSColor) {
        if #available(macOS 12.0, *) {
            self.init(nsColor: color)
        } else {
            self.init(color)
        }
    }

    public init(cg color: CGColor) {
        if #available(macOS 12.0, *) {
            self.init(cgColor: color)
        } else {
            self.init(color)
        }
    }

}

extension NSColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") { hexSanitized.removeFirst() }

        guard [3, 4, 6, 8].contains(hexSanitized.count) else { return nil }

        var hexValue: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&hexValue) else { return nil }

        let (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat)

        switch hexSanitized.count {
        case 3:  // RGB (e.g. F60)
            r = CGFloat((hexValue >> 8) & 0xF) / 15.0
            g = CGFloat((hexValue >> 4) & 0xF) / 15.0
            b = CGFloat(hexValue & 0xF) / 15.0
            a = 1.0
        case 4:  // ARGB (e.g. FFF0)
            a = CGFloat((hexValue >> 12) & 0xF) / 15.0
            r = CGFloat((hexValue >> 8) & 0xF) / 15.0
            g = CGFloat((hexValue >> 4) & 0xF) / 15.0
            b = CGFloat(hexValue & 0xF) / 15.0
        case 6:  // RRGGBB (e.g. FF6600)
            r = CGFloat((hexValue >> 16) & 0xFF) / 255.0
            g = CGFloat((hexValue >> 8) & 0xFF) / 255.0
            b = CGFloat(hexValue & 0xFF) / 255.0
            a = 1.0
        case 8:  // AARRGGBB (e.g. FFFF6600)
            a = CGFloat((hexValue >> 24) & 0xFF) / 255.0
            r = CGFloat((hexValue >> 16) & 0xFF) / 255.0
            g = CGFloat((hexValue >> 8) & 0xFF) / 255.0
            b = CGFloat(hexValue & 0xFF) / 255.0
        default:
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
