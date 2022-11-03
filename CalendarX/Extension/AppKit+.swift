//
//  AppKit+.swift
//  CalendarX
//
//  Created by zm on 2022/1/25.
//


import SwiftUI

extension NSEvent {
    var isRightClicked: Bool {
        type == .rightMouseDown || modifierFlags.contains(.control)
    }
}

extension NSWorkspace {
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
        guard let id = bundleIdentifier else { return }
        let apps = NSRunningApplication
            .runningApplications(withBundleIdentifier: id)
            .filter{ $0 != self }
        apps.forEach{ $0.terminate() }
    }
}

extension NSStatusBarButton {

    
    func setImage(_ image: NSImage?, title: String) {
        DispatchQueue.main.async {
            self.image = image
            if let _image = image {
                _image.size = .init(width: 16, height: 16)
                _image.isTemplate = true
                self.attributedTitle =  NSAttributedString(string: title, attributes: [.baselineOffset: -1,.font: NSFont.systemFont(ofSize: 8.5)])
            } else {
                self.title = title
            }
        }
    }
}

extension Array {
    var isNotEmpty: Bool { !isEmpty }
}

extension String {
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

}


