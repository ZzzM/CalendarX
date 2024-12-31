//
//  ScacleButtonPicker.swift
//  CalendarX
//
//  Created by zm on 2022/1/28.
//
import SwiftUI

struct ScacleButtonPicker<Item: Hashable, Label: View, ItemLabel: View>: View {


    private let items: [Item]

    @Binding
    private var selection: Item

    @Binding
    private var isPresented: Bool

    private let label: () -> Label, itemLabel: (Item) -> ItemLabel

    private let tint: Color, width: CGFloat, arrowEdge: Edge


    @Environment(\.colorScheme)
    private var colorScheme

    @Environment(\.locale)
    private var locale


    init(
        items: [Item],
        tint: Color,
        width: CGFloat = .popoverWidth,
        arrowEdge: Edge = .bottom,
        selection: Binding<Item>,
        isPresented: Binding<Bool>,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder itemLabel: @escaping (Item) -> ItemLabel
    ) {
        self.items = items
        self.tint = tint
        self.width = width
        self.arrowEdge = arrowEdge
        self._selection = selection
        self._isPresented = isPresented
        self.label = label
        self.itemLabel = itemLabel
    }

    var body: some View {
        ScacleButton {
            DispatchQueue.main.async {
                isPresented.toggle()
            }
        } label: {
            label()
        }
        .popover(isPresented: $isPresented, attachmentAnchor: .rect(.bounds), arrowEdge: arrowEdge) {
            popoverContent()
                .preferredLocale(locale)
                .preferredColorScheme(colorScheme)
        }
    }

    @ViewBuilder
    func popoverContent() -> some View {
        ScrollViewReader { reader in
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.fixed(width))], spacing: 0) {
                    ForEach(items, id: \.self) { item in
                        Button {
                            selection = item
                            isPresented.toggle()
                        } label: {
                            itemLabel(item)
                                .appForeground(item == selection ? tint : .primary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                        }
                        .id(item)
                        .buttonStyle(.plain)
                        .frame(height: .popoverRowHeight)
                    }
                }
                .padding(5)
            }
            .frame(height: min(CGFloat(items.count) * .popoverRowHeight + 10, .popoverHeight))
            .onAppear { reader.scrollTo(selection) }
        }
    }
}
