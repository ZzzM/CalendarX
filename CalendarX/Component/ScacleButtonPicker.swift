//
//  ScacleButtonPicker.swift
//  CalendarX
//
//  Created by zm on 2022/1/28.
//
import SwiftUI


struct ScacleButtonPicker<Item: Hashable, Label: View, ItemLabel: View>: View  {
    
    private let items: [Item]

    @Binding
    private var selection: Item

    @Binding
    private var isPresented: Bool

    private let label: () -> Label, itemLabel: (Item) -> ItemLabel

    private let tint: Color, width: CGFloat, arrowEdge: Edge, locale: Locale, colorScheme: ColorScheme?

    init(items: [Item],
         tint: Color,
         width: CGFloat = .popoverWidth,
         arrowEdge: Edge = .bottom,
         locale: Locale = .current,
         colorScheme: ColorScheme? = .none,
         selection: Binding<Item>,
         isPresented: Binding<Bool>,
         @ViewBuilder label: @escaping ()-> Label,
         @ViewBuilder itemLabel:  @escaping (Item) -> ItemLabel) {
        self.items = items
        self.tint = tint
        self.width = width
        self.arrowEdge = arrowEdge
        self.locale = locale
        self.colorScheme = colorScheme
        self._selection = selection
        self._isPresented = isPresented
        self.label = label
        self.itemLabel = itemLabel
    }
    
    var body: some View {
        
        ScacleButton {
            isPresented.toggle()
        } label: {
            label()
        }
        .popover(isPresented: $isPresented, attachmentAnchor: .rect(.bounds), arrowEdge: arrowEdge) {
            popoverContent()
                .environment(\.locale, locale)
                .preferredColorScheme(colorScheme)
        }

    }

    @ViewBuilder
    func popoverContent() -> some View {
        ScrollViewReader { reader in
            ScrollView {
                LazyVStack {
                    ForEach(items, id: \.self) { item in
                        Button {
                            selection = item
                            isPresented.toggle()
                        } label: {
                            itemLabel(item)
                                .foregroundColor(item == selection ? tint:.primary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                        }
                        .id(item)
                        .buttonStyle(.plain)
                        .frame(minWidth: width, idealHeight: .popoverRowHeight)
                    }
                }
                .padding(5)
            }
            .frame(height: min(CGFloat(items.count + 1) * .popoverRowHeight + 10, .popoverHeight))
            .onAppear { reader.scrollTo(selection) }
        }
    }

}

