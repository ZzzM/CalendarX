//
//  MenubarIcon.swift
//  CalendarX
//
//  Created by zm on 2024/12/30.
//

import AppKit

// MARK: Menubar Icon Style
@MainActor
enum MenubarIcon: String, Codable, Hashable, CaseIterable {
    case c = "calendar"
    case n = "note"
    case s = "square"
    case sf = "square.fill"
    case md, wd, lmld

    
    
    func nsImage(locale: Locale) -> NSImage {
        guard let symbolName else {
            return drawImge(locale: locale)
        }

        let symbol = NSImage(
            systemSymbolName: symbolName,
            accessibilityDescription: .none
        )!

        let image = NSImage(size: size, flipped: false) { dstRect -> Bool in
            symbol.draw(in: dstRect)
            return true
        }

        image.isTemplate = true

        return image
    }


    var title: String {
        switch self {
        case .n: Date().day.description
        default: ""
        }
    }

    var size: NSSize {
        switch self {
        case .md, .lmld, .wd: .init(width: 18, height: 17)
        default: .init(width: 20, height: 18)
        }
    }

    private var symbolName: String? {
        switch self {
        case .s, .sf: date.day.description + "." + rawValue
        case .c, .n: rawValue
        default: .none
        }
    }

    
    private func drawImge(locale: Locale) -> NSImage {
        let title =
            switch self {
            case .md: date.sm(locale: locale)
            case .lmld: date.lm
            case .wd: date.e(locale: locale)
            default: ""
            } as NSString

        let subtitle =
            switch self {
            case .md, .wd: date.day.description
            case .lmld: date.ld
            default: ""
            } as NSString

        let titleSize: CGFloat =
            switch self {
            case .md, .wd: 7
            case .lmld: 7
            default: .zero
            }

        let subtitleSize: CGFloat =
            switch self {
            case .md, .wd: 8
            case .lmld: 7
            default: .zero
            }

        let nsImage = NSImage(size: size)

        let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .calibratedRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        )

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
            .font: NSFont.monospacedSystemFont(ofSize: titleSize, weight: .medium)
        ]

        let topSize = title.size(withAttributes: topAttributes)
        let topPoint = CGPoint(x: (size.width - topSize.width) / 2, y: size.height - topSize.height - 0.5)
        title.draw(at: topPoint, withAttributes: topAttributes)

        let bottomAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedDigitSystemFont(ofSize: subtitleSize, weight: .semibold)
        ]

        let bottomSize = subtitle.size(withAttributes: bottomAttributes)
        let bottomPoint = CGPoint(x: (size.width - bottomSize.width) / 2, y: 0)
        subtitle.draw(at: bottomPoint, withAttributes: bottomAttributes)

        nsImage.unlockFocus()

        nsImage.isTemplate = true

        return nsImage
    }
    
    
    private var date: Date { Date() }
}
