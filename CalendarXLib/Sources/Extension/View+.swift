//
//  View+.swift
//  CalendarX
//
//  Created by zm on 2022/1/27.
//

import SwiftUI
import WidgetKit

extension View {


    @ViewBuilder
    public func focusDisabled(_ disabled: Bool = true) -> some View {
        if #available(macOS 14.0, *) {
            focusEffectDisabled(disabled)
        } else if #available(macOS 12.0, *) {
            focusable(!disabled)
        } else {
            focusable(!disabled, onFocusChange: { _ in })
        }
    }

    @ViewBuilder
    public func appForeground(_ color: Color) -> some View {
        if #available(macOS 14.0, *) {
            foregroundStyle(color)
        } else {
            foregroundColor(color)
        }
    }


    @ViewBuilder
    public func preferredLocale(_ locale: Locale) -> some View {
        environment(\.locale, locale)
    }

    @ViewBuilder
    public func envColorScheme(_ colorScheme: ColorScheme?) -> some View {
        if let colorScheme {
            self.colorScheme(colorScheme)
        } else {
            self
        }
    }

    @ViewBuilder
    public func envTint(_ tint: Color) -> some View {
        if #available(macOS 12.0, *) {
            self.tint(tint).accentColor(tint)
        } else {
            self.accentColor(tint)
        }
    }
}

struct HoverModifier: ViewModifier {
    @State
    private var hovered = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(hovered ? 1.01 : 1.0)
            .animation(.default, value: hovered)
            .onHover { isHovered in
                hovered = isHovered
            }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
    }
}

struct CheckboxStyle: ToggleStyle {
    private let offsetX: CGFloat = 8

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            Spacer()

            ZStack {
                Capsule()
                    .frame(width: 35, height: 20)
                    .appForeground(configuration.isOn ? .accentColor : .disable)
                Circle()
                    .frame(width: 10, height: 10)
                    .appForeground(.white)
                    .offset(x: configuration.isOn ? offsetX : -offsetX)
            }
        }
        .onTapGesture {
            withAnimation {
                configuration.isOn.toggle()
            }
        }
    }
}

extension View {
    public func checkboxStyle() -> some View {
        toggleStyle(CheckboxStyle())
    }

    public func scaleStyle() -> some View {
        buttonStyle(ScaleButtonStyle())
    }
}

extension View {
    public func onChange<V: Equatable>(of value: V, notification name: NSNotification.Name) -> some View {
        if #available(macOS 14.0, *) {
            return onChange(of: value) {
                NotificationCenter.default.post(name: name, object: .none)
            }
        } else {
            return onChange(of: value) { _ in
                NotificationCenter.default.post(name: name, object: .none)
            }
        }
    }

    public func fullScreenCover(_ backgroudColor: Color) -> some View {
        background(backgroudColor)
            .transition(.move(edge: .trailing))
            .zIndex(1)
    }

    public var hoverEffect: some View {
        modifier(HoverModifier())
    }
}

extension View {
    public func sideLength(_ width: CGFloat) -> some View {
        frame(width: width, height: width)
    }
}
