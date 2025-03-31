//
//  SegmentedPicker.swift
//  CalendarX
//
//  Created by zm on 2025/3/10.
//

import SwiftUI

struct SegmentedPicker<Item: Hashable,  ItemLabel: View>: View {
    let items: [Item]
    @Binding
    var selection: Item
    let itemLabel: (Item) -> ItemLabel

    var body: some View {
        
        let width: CGFloat = (.mainWidth - 36) / CGFloat(items.count),
            height: CGFloat = 22,
            hGap: CGFloat = 6,
            vGap: CGFloat = 6,
            cornerRadius: CGFloat = 6
        
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: cornerRadius / 1.5)
                .fill(Color.accentColor)
                .frame(width: width - hGap, height: height - vGap)
                .offset(x: CGFloat(items.firstIndex(of: selection) ?? 0) * width + hGap/2)
                .animation(.spring, value: selection)

            HStack(spacing: 0) {
                ForEach(items, id: \.self) { item in
                    Button(action: {
                        withAnimation(.spring) {
                            selection = item
                        }
                    }) {
                        itemLabel(item)
                            .appForeground(.appWhite)
                            .font(.subheadline)
                            .frame(width: width, height: height)
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
        .frame(width: width * CGFloat(items.count), height: height)
        .background(Color.disable)
        .clipShape(.rect(cornerRadius: cornerRadius))
    }
}
