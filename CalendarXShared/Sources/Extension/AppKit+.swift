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
        let views = Array<Any>(topLevelArray!).filter { $0 is Self }
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

public extension NSWorkspace {
    static func searching(_ keyword: String) {
        let urlString =  "https://www.baidu.com/s?wd=" + keyword.urlEncoded
        open(urlString)
    }
    static func open(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        shared.open(url)
    }
    static func openPreference(_ privacy: String) {
        NSWorkspace.open("x-apple.systempreferences:\(privacy)")
    }
}

extension NSRunningApplication {
    func quitSameApps() {
        guard let bundleIdentifier else { return }
        let apps = NSRunningApplication
            .runningApplications(withBundleIdentifier: bundleIdentifier)
            .filter{ $0 != self }
        apps.forEach{ $0.terminate() }
    }
}

public extension Array {
    var isNotEmpty: Bool { !isEmpty }
}

extension Array: RawRepresentable where Element: Codable {
    
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


public extension String {
    var urlEncoded: String {
        addingPercentEncoding(withAllowedCharacters:
                                    .alphanumerics) ?? self
    }

    var urlDecoded: String {
        removingPercentEncoding ?? self
    }

    var l10nKey: LocalizedStringKey {
        LocalizedStringKey(self)
    }
    
    func localized(_ bundle: Bundle = .main, args: CVarArg...) -> String {
        String(format: NSLocalizedString(self, bundle: bundle, comment: "\(self)_comment"), arguments: args)
    }
    
}

public extension Binding where Value == String {
    func max(_ limit: Int = 30) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}

public extension Locale {
    var inChinese: Bool { identifier.contains("zh") }
}
