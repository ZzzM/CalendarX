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

    private let tint: Color, isGrid: Bool, arrowEdge: Edge, locale: Locale, colorScheme: ColorScheme?

    init(items: [Item],
         tint: Color,
         isGrid: Bool = false,
         arrowEdge: Edge = .bottom,
         locale: Locale = .current,
         colorScheme: ColorScheme? = .none,
         selection: Binding<Item>,
         isPresented: Binding<Bool>,
         @ViewBuilder label: @escaping ()-> Label,
         @ViewBuilder itemLabel:  @escaping (Item) -> ItemLabel) {
        self.items = items
        self.tint = tint
        self.isGrid = isGrid
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
        if isGrid {
            gridView()
        } else {
            listView()
        }
    }

    func gridView() -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
            ForEach(items, id: \.self) { item in
                Button {
                    selection = item
                    isPresented.toggle()
                } label: {
                    itemLabel(item)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(5)
    }

    func listView() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(items, id: \.self) { item in
                        Button {
                            selection = item
                            isPresented.toggle()
                        } label: {
                            itemLabel(item)
                                .foregroundColor(item == selection ? tint:.primary)
                        }
                        .id(item)
                        .buttonStyle(.plain)
                        .frame(minWidth: .popoverWidth, idealHeight: .popoverRowHeight)
                    }
                }.padding(5)
            }
            .frame(height: min(CGFloat(items.count + 1) * .popoverRowHeight + 10, .popoverHeight))
            .onAppear { proxy.scrollTo(selection) }
        }
    }

}

