//
//  View+.swift
//  CalendarX
//
//  Created by zm on 2022/1/27.
//

import SwiftUI

struct TintModifier: ViewModifier {
    
    let tint: Color
    
    func body(content: Content) -> some View {
        if #available(macOS 12.0, *) {
            content.tint(tint).accentColor(tint)
        } else {
            content.accentColor(tint)
        }
    }
}

struct ColorSchemeModifier: ViewModifier {
    
    let colorScheme: ColorScheme?
    
    func body(content: Content) -> some View {
        
        if let _colorScheme = colorScheme {
            content.colorScheme(_colorScheme)
        } else {
            content
        }
    }
}

struct HoverModifier: ViewModifier {
    
    @State
    private var hovered = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(hovered ? 1.2 : 1.0)
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
                    .frame(width: 30, height: 15)
                    .foregroundColor(configuration.isOn ? .accentColor : .secondary)
                Circle()
                    .square(8)
                    .foregroundColor(.white)
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

extension View  {
    func checkboxStyle() -> some View {
        toggleStyle(CheckboxStyle())
    }

    func scaleStyle() -> some View {
        buttonStyle(ScaleButtonStyle())
    }
}

extension View {

    func square(_ length: CGFloat) -> some View {
        frame(width: length, height: length)
    }
    func height(_ length: CGFloat) -> some View {
        frame(height: length)
    }
    func width(_ length: CGFloat) -> some View {
        frame(width: length)
    }
}


extension View {

    func onChange<V: Equatable>(of value: V, notification name: NSNotification.Name) -> some View {
        onChange(of: value) { _ in
            NotificationCenter.default.post(name: name, object: .none)
        }
    }

    func xTint(_ tint: Color) -> some View {
        modifier(TintModifier(tint: tint))
    }

    func xColorScheme(_ colorScheme: ColorScheme?) -> some View {
        modifier(ColorSchemeModifier(colorScheme: colorScheme))
    }
    
    var hoverEffect: some View {
        modifier(HoverModifier())
    }
    
}


