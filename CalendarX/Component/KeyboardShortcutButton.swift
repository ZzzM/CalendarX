//
//  KeyboardShortcutButton.swift
//  CalendarX
//
//  Created by zm on 2025/3/25.
//
import CalendarXLib
import SwiftUI

struct KeyboardShortcutButton: View {

    let key: KeyEquivalent
    let action: VoidClosure
    
    var body: some View {
        Button("", action: action)
            .keyboardShortcut(key, modifiers: [])
            .buttonStyle(.borderless)
    }
}
