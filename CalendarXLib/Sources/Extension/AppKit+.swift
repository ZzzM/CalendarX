//
//  AppKit+.swift
//  CalendarX
//
//  Created by zm on 2022/1/25.
//

import SwiftUI

extension NSView {
    static var nibName: String {
        return String(describing: Self.self)
    }

    static func loadFromNib(in bundle: Bundle = Bundle.main) -> Self {
        var topLevelArray: NSArray? = nil
        bundle.loadNibNamed(NSNib.Name(nibName), owner: self, topLevelObjects: &topLevelArray)
        let views = [Any](topLevelArray!).filter { $0 is Self }
        return views.last as! Self
    }

    var imageRepresentation: NSImage? {
        guard let rep = bitmapImageRepForCachingDisplay(in: bounds) else { return .none }
        cacheDisplay(in: bounds, to: rep)
        let image = NSImage(size: bounds.size)
        image.addRepresentation(rep)
        image.isTemplate = true
        return image
    }
}

extension NSEvent {
    public var isRightClicked: Bool {
        type == .rightMouseDown || modifierFlags.contains(.control)
    }
}

extension Array {
    public var isNotEmpty: Bool { !isEmpty }
}

extension Array: Swift.RawRepresentable where Element: Codable {

    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension String {
    public var urlEncoded: String {
        addingPercentEncoding(
            withAllowedCharacters:
                .alphanumerics
        ) ?? self
    }

    public var urlDecoded: String {
        removingPercentEncoding ?? self
    }

    public var l10nKey: LocalizedStringKey {
        LocalizedStringKey(self)
    }

    public func localized(_ bundle: Bundle = .main, args: CVarArg...) -> String {
        String(format: NSLocalizedString(self, bundle: bundle, comment: "\(self)_comment"), arguments: args)
    }
}

extension Binding where Value == String {
    public func max(_ limit: Int = 30) -> Self {
        if wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}

extension Locale {
    public var inChinese: Bool { identifier.contains("zh") }
    public var bundle: Bundle {
        let resource = switch self {
        case .zh: "zh-Hans"
        case .en: "en"
        default: "zh-Hans"
        }
        guard let path = Bundle.main.path(forResource: resource, ofType: "lproj") else { return .main }
        return Bundle(path: path) ?? .main
    }
}
