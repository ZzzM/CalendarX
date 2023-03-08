//
//  SegmentedPicker.swift
//  CalendarX
//
//  Created by zm on 2023/2/17.
//

import SwiftUI

struct SegmentedPicker<Value: Hashable, Content: View>: View {
    
    let tabs: [Value]
    
    @Binding
    var selection: Value

    let itemView: (Value) -> Content
    
    @State
    private var offsetX: CGFloat = 0
    
    
    private let itemWidth: CGFloat = 90, itemHeight: CGFloat = 25
    
    var body: some View {
        
        ZStack {
            Color.disable
            Capsule()
                .foregroundColor(.accentColor)
                .frame(width: itemWidth, height: itemHeight)
                .position(x: itemWidth / 2 + offsetX, y: itemHeight / 2)
            HStack(spacing: .zero) {
                ForEach(Array(tabs.enumerated()), id: \.offset) {  tab in
                    Button {
                        selection = tab.element
                        withAnimation {
                            offsetX = CGFloat(tab.offset) * itemWidth
                        }
                    } label: {
                        itemView(tab.element)
                            .frame(width: itemWidth,  height: itemHeight)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                    }
                    .buttonStyle(.borderless)
                }
            }
            .onAppear{
                let index = tabs.firstIndex(of: selection) ?? 0
                offsetX = CGFloat(index) * itemWidth
            }
        }
        .frame(width: itemWidth * CGFloat(tabs.count),  height: itemHeight)
        .clipShape(Capsule(style: .circular))
        
    }
}
