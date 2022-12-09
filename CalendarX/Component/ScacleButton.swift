//
//  ScacleButton.swift
//  CalendarX
//
//  Created by zm on 2022/1/27.
//

import SwiftUI


struct ScacleButton<Label: View>: View {
    let action: VoidClosure
    
    @ViewBuilder
    let label: () -> Label
    
    var body: some View {
        Button(action: action, label: label).scaleStyle()
    }
}


struct ScacleImageButton: View {
    let image: Image, action: VoidClosure
    var body: some View {
        ScacleButton(action: action, label: { image.foregroundColor(.secondary) })
    }
}

struct ScacleTagButton: View {
    let title: LocalizedStringKey, action: VoidClosure
    var body: some View {
        ScacleButton(action: action) {
            Text(title)
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
                .background(Color.accentColor.opacity(0.1))
                .foregroundColor(.accentColor)
                .clipShape(Capsule())
        }
    }
}

struct ScacleCapsuleButton: View {
    let title: LocalizedStringKey,
        foregroundColor: Color,
        backgroundColor: Color,
        action: VoidClosure
    
    var body: some View {
        ScacleButton(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 5)
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
                .clipShape(Capsule())
        }
    }
}

