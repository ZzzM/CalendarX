//
//  RotationArrow.swift
//  CalendarX
//
//  Created by zm on 2022/3/29.
//

import SwiftUI
struct RotationArrow: View {
    @Binding
    var isPresented: Bool
    var body: some View {
        Image.rightArrow
            .foregroundColor(.secondary)
            .rotationEffect(.degrees(isPresented ? 90 : 0))
            .animation(.spring(), value: isPresented)
    }
}
