//
//  View+.swift
//  CalendarX
//
//  Created by zm on 2022/1/27.
//

import SwiftUI
import WidgetKit

public extension View {

    @ViewBuilder
    func appForeground(_ color: Color) -> some View {
        if #available(macOS 14.0, *) {
            foregroundStyle(color)
        } else {
            foregroundColor(color)
        }
    }
    
}

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
        
        if let colorScheme {
            content.colorScheme(colorScheme)
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

public extension View  {
    func checkboxStyle() -> some View {
        toggleStyle(CheckboxStyle())
    }

    func scaleStyle() -> some View {
        buttonStyle(ScaleButtonStyle())
    }
}


public extension View {

    func onChange<V: Equatable>(of value: V, notification name: NSNotification.Name) -> some View {

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

    func envTint(_ tint: Color) -> some View {
        modifier(TintModifier(tint: tint))
    }

    func envColorScheme(_ colorScheme: ColorScheme?) -> some View {
        modifier(ColorSchemeModifier(colorScheme: colorScheme))
    }
    
    
    func fullScreenCover(_ backgroudColor: Color = .appBackground) -> some View {
        background(backgroudColor)
            .transition(.move(edge: .trailing))
            .zIndex(1)
    }
    
    
    var hoverEffect: some View {
        modifier(HoverModifier())
    }
    

}

public extension View {
    func sideLength(_ width: CGFloat) -> some View {
        frame(width: width, height: width)
    }
}




