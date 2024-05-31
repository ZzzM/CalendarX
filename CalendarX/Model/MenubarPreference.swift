//
//  MenubarPreference.swift
//  CalendarX
//
//  Created by zm on 2023/2/13.
//

import SwiftUI
import CalendarXShared


//MARK: Menubar Icon Style
enum IconType: String, Codable, Hashable, CaseIterable {
    case c = "calendar", n = "note",
         s = "square", sf = "square.fill",
         md, wd, lmld


    var nsImage: NSImage {

        guard let symbolName else {
            return nsIcon
        }

        let symbol = NSImage(systemSymbolName: symbolName,
                                    accessibilityDescription: .none)!

        let image = NSImage(size: size, flipped: false) { (dstRect) -> Bool in
            symbol.draw(in: dstRect)
            return true
        }

        image.isTemplate = true

        return image
    }

    var title: String {
        switch self {
        case .n: return Date().day.description
        default: return ""
        }
    }

    var size: NSSize {
        switch self {
        case .md, .lmld, .wd: return .init(width: 18, height: 17)
        default: return .init(width: 20, height: 18)
        }
    }

    private var symbolName: String? {
        switch self {
        case .s, .sf: return date.day.description + "." + rawValue
        case .c, .n: return rawValue
        default: return .none
        }
    }

    private var nsIcon: NSImage {


        let title = switch self {
        case .md:  L10n.sm(from: date)
        case .lmld:  L10n.lm(from: date)
        case .wd:  L10n.e(from: date)
        default:  ""
        } as NSString

        let subtitle = switch self {
        case .md, .wd:  date.day.description
        case .lmld:  L10n.ld(from: date)
        default: ""
        } as NSString

        let titleSize: CGFloat = switch self {
        case .md, .wd:  7
        case .lmld:  7
        default: .zero
        }

        let subtitleSize: CGFloat = switch self {
        case .md, .wd:  8
        case .lmld:  7
        default: .zero
        }

        let nsImage = NSImage(size: size)

        let rep = NSBitmapImageRep(bitmapDataPlanes: nil,
                                   pixelsWide: Int(size.width),
                                   pixelsHigh: Int(size.height),
                                   bitsPerSample: 8,
                                   samplesPerPixel: 4,
                                   hasAlpha: true,
                                   isPlanar: false,
                                   colorSpaceName: .calibratedRGB,
                                   bytesPerRow: 0,
                                   bitsPerPixel: 0)


        nsImage.addRepresentation(rep!)
        nsImage.lockFocus()

        let rect = NSRect(x: 0, y: 0, width: size.width, height: size.height)

        let ctx = NSGraphicsContext.current?.cgContext
        ctx!.clear(rect)

        ctx?.beginPath()
        ctx?.addPath(CGPath(roundedRect: rect, cornerWidth: 2.5, cornerHeight: 2.5, transform: .none))
        ctx?.closePath()
        ctx?.clip()

        ctx!.fill(rect)

        ctx?.setBlendMode(.clear)

        let topAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedSystemFont(ofSize: titleSize, weight: .bold)]

        let topSize = title.size(withAttributes: topAttributes)
        let topPoint = CGPoint(x: (size.width - topSize.width) / 2, y: size.height - topSize.height - 0.5)
        title.draw(at: topPoint, withAttributes: topAttributes)

        let bottomAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedDigitSystemFont(ofSize: subtitleSize, weight: .heavy)]

        let bottomSize = subtitle.size(withAttributes: bottomAttributes)
        let bottomPoint = CGPoint(x: (size.width - bottomSize.width) / 2, y: 0)
        subtitle.draw(at: bottomPoint, withAttributes: bottomAttributes)

        nsImage.unlockFocus()

        nsImage.isTemplate = true

        return nsImage
    }


    private var date: Date { Date() }

}


//MARK: Menubar Date&Time Style
enum DTType: String, Codable, Hashable {
    case lm, ld, sm, sd, e, a, t
}

extension [DTType]  {

    func generateTitle(transform: (DTType) -> String) -> String {
        let condition: (DTType, DTType) -> Bool = {
            if L10n.inChinese {
                ($0 == .lm && $1 == .ld) ||
                ($0 == .sm && $1 == .sd)
            } else {
                $0 == .lm && $1 == .ld
            }
        }
        return self
            .chunked(by:condition)
            .map { $0.reduce("") { $0 + transform($1) } }
            .joined(separator: " ")
    }
}

struct MenubarPreference  {

    static let shared = MenubarPreference()

    @AppStorage(MenubarStorageKey.style, store: .group)
    var style: MenubarStyle = .icon

    // Date Style
    // Use a 24-hour clock
    @AppStorage(MenubarStorageKey.use24h, store: .group)
    var use24h: Bool = true

    // Display the time with seconds
    @AppStorage(MenubarStorageKey.showSeconds, store: .group)
    var showSeconds: Bool = false

    @AppStorage(MenubarStorageKey.shownTypes, store: .group)
    var shownTypes: [DTType] = [.sm, .sd, .e, .t]

    @AppStorage(MenubarStorageKey.hiddenTypes, store: .group)
    var hiddenTypes: [DTType] = [.lm, .ld, .a]

    // Icon Style
    @AppStorage(MenubarStorageKey.iconType, store: .group)
    var iconType: IconType = .c
}



extension MenubarPreference {

    var iconItemTitle: String {
        iconType.title
    }

    var dateItemTitle: String {
        shownTypes.generateTitle(transform: transform)
    }

    private func transform(_ type: DTType) -> String {
        let date = Date()
        switch type {
        case .lm: return L10n.lm(from: date)
        case .ld: return L10n.ld(from: date)
        case .sm: return L10n.sm(from: date)
        case .sd: return L10n.sd(from: date)
        case .e: return L10n.e(from: date)
        case .a: return L10n.a(from: date)
        case .t: return L10n.t(from: date, use24h: use24h, showSeconds: showSeconds)
        }
    }

}


