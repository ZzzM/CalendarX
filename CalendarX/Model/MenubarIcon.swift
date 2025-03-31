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

        let date = Date()

        return switch self {
        case .c: drawImage(rawValue)
        case .s, .sf: drawImage(date.day.description + "." + rawValue)
        case .n: drawTextOnImage(date.day.description)
        default: drawTextImge(locale: locale, date: date)
        }

    }

    var size: NSSize {
        switch self {
        case .md, .lmld, .wd: .init(width: 22, height: 20)
        case .n: .init(width: 24, height: 22)
        default: .init(width: 22, height: 20)
        }
    }

    private func drawImage(_ name: String) -> NSImage {
        let image = NSImage(
            systemSymbolName: name,
            accessibilityDescription: .none
        )!

        let newImage = NSImage(size: size, flipped: false) {
            image.draw(in: $0)
            return true
        }

        newImage.isTemplate = true

        return newImage
    }

    private func drawTextOnImage(_ text: String) -> NSImage {
        let image = NSImage(
            systemSymbolName: rawValue,
            accessibilityDescription: .none
        )!

        let newImage = NSImage(size: size, flipped: false) { rect in

            let attributedString = NSAttributedString(string: text, attributes: [.font: NSFont.statusIcon])

            let textSize = attributedString.size()

            let point = CGPoint(
                x: (rect.width - textSize.width) / 2,
                y: (rect.height - textSize.height) / 2 - 1.5
            )

            image.draw(in: rect)

            attributedString.draw(at: point)

            return true
        }

        newImage.isTemplate = true

        return newImage
    }

    private func drawTextImge(locale: Locale, date: Date) -> NSImage {
        let title =
            switch self {
            case .md: date.sm(locale: locale)
            case .wd: date.e(locale: locale)
            default: date.lm
            }

        let titleFont: NSFont =
            switch self {
            case .md, .wd: .monospacedSystemFont(ofSize: 10, weight: .bold)
            default: .monospacedSystemFont(ofSize: 9.5, weight: .bold)
            }
        
        let titleOffset: CGFloat =
            switch self {
            case .md, .wd: -1
            default: -0.5
            }

        let subtitle =
            switch self {
            case .md, .wd: date.day.description
            default: date.ld
            }

        let subtitleFont: NSFont =
            switch self {
            case .md, .wd: .monospacedSystemFont(ofSize: 10, weight: .bold)
            default: .monospacedSystemFont(ofSize: 9.5, weight: .bold)
            }

        let subtitleOffset: CGFloat =
            switch self {
            case .md, .wd: -1
            default: -0.5
            }
        
        let image = NSImage(size: size, flipped: false) { rect in

            let roundedPath = NSBezierPath(roundedRect: rect, xRadius: 1.5, yRadius: 1.5)
            roundedPath.addClip()
            rect.fill()

            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: titleFont
            ]
            let titleAttributedString = NSAttributedString(string: title, attributes: titleAttributes)
            let titleSize = titleAttributedString.size()
            let titlePoint = CGPoint(
                x: (rect.width - titleSize.width) / 2,
                y: rect.height - titleSize.height - titleOffset
            )

            let subtitleAttributes: [NSAttributedString.Key: Any] = [
                .font: subtitleFont
            ]
            let subtitleAttributedString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
            let subtitleSize = subtitleAttributedString.size()
            let subtitlePoint = CGPoint(
                x: (rect.width - subtitleSize.width) / 2,
                y: subtitleOffset
            )
            NSGraphicsContext.current?.compositingOperation = .destinationOut
            titleAttributedString.draw(at: titlePoint)
            subtitleAttributedString.draw(at: subtitlePoint)
            return true
        }

        image.isTemplate = true

        return image
    }

}
