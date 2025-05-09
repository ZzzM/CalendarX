//
//  ScacleButton.swift
//  CalendarX
//
//  Created by zm on 2022/1/27.
//

import CalendarXLib
import SwiftUI

struct ScacleButton<Label: View>: View {
    let action: VoidClosure

    @ViewBuilder
    let label: () -> Label

    var body: some View {
        Button(action: action, label: label)
            .scaleStyle()
    }
}

struct ScacleImageButton: View {
    private let image: Image, color: Color, action: VoidClosure

    init(image: Image, color: Color = .appSecondary, action: @escaping VoidClosure) {
        self.image = image
        self.color = color
        self.action = action
    }

    var body: some View {
        ScacleButton(action: action) {
            image
                .font(.title3)
                .appForeground(color)
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
                .background(backgroundColor)
                .appForeground(foregroundColor)
                .clipShape(.capsule)
        }
    }
}
