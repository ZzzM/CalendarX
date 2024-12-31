//
//  MenubarScreen.swift
//  CalendarX
//
//  Created by zm on 2024/10/27.
//

import CalendarXLib
import SwiftUI

struct MenubarScreen: View {

    @EnvironmentObject
    private var router: Router

    @EnvironmentObject
    private var menubarStore: MenubarStore

    @State
    private var style: MenubarStyle

    @State
    private var iconType: MenubarIcon

    @State
    private var shownTypes: [MenubarDateType]

    @State
    private var hiddenTypes: [MenubarDateType]

    @State
    private var use24h: Bool

    @State
    private var showSeconds: Bool

    init(menubarStore: MenubarStore) {
        style = menubarStore.style
        iconType = menubarStore.iconType
        shownTypes = menubarStore.shownTypes
        hiddenTypes = menubarStore.hiddenTypes
        use24h = menubarStore.use24h
        showSeconds = menubarStore.showSeconds
    }

    var body: some View {
        VStack(spacing: 10) {
            TitleView {
                Text(L10n.Settings.menubarStyle)
            } leftItems: {
                ScacleImageButton(image: .backward) {
                    router.pop()
                }
            } rightItems: {
                ScacleImageButton(image: .save) {
                    save()
                }
            }

            Picker(selection: $style) {
                ForEach(MenubarStyle.allCases, id: \.self) {
                    Text($0.title)
                }
            } label: {
                EmptyView()
            }
            .pickerStyle(.segmented)

            ZStack {
                switch style {
                case .icon: IconStyleView(iconType: $iconType)
                case .date:
                    DateStyleView(
                        shownTypes: $shownTypes,
                        hiddenTypes: $hiddenTypes,
                        use24h: $use24h,
                        showSeconds: $showSeconds
                    )
                }
            }
            .frame(maxHeight: .infinity)
        }
        .focusable(false)
        .padding()
    }
}

extension MenubarScreen {
    private func save() {
        if style == .date {
            menubarStore.showSeconds = showSeconds
            menubarStore.use24h = use24h
            menubarStore.shownTypes = shownTypes
            menubarStore.hiddenTypes = hiddenTypes
        } else if style == .icon {
            menubarStore.iconType = iconType
        }
        menubarStore.style = style
        NotificationCenter.default.post(name: .titleStyleDidChanged, object: .none)
        router.pop()
    }
}

struct IconStyleView: View {

    @Environment(\.locale)
    private var locale

    @Binding
    var iconType: MenubarIcon

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: .init(spacing: 0), count: 3), spacing: 0) {
                    ForEach(MenubarIcon.allCases, id: \.self) { type in

                        ScacleButton {
                            iconType = type

                        } label: {
                            ZStack {
                                if type == iconType {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.accentColor, lineWidth: 3)
                                }

                                Text(type.title)
                                    .font(.caption2)
                                    .offset(y: 1)

                                Image(nsImage: type.nsImage(locale: locale))
                                    .resizable()
                                    .frame(
                                        width: type.size.width,
                                        height: type.size.height
                                    )
                            }
                            .sideLength(40)
                            .padding()
                        }
                    }
                }.padding()
            }
        }
    }
}

@MainActor
struct DateStyleView: View {

    @Environment(\.locale)
    private var locale

    @Binding
    var shownTypes: [MenubarDateType]

    @Binding
    var hiddenTypes: [MenubarDateType]

    @Binding
    var use24h: Bool

    @Binding
    var showSeconds: Bool

    private var dateTitle: String {
        shownTypes.generateTitle(locale: locale, transform: transform)
    }

    var body: some View {
        VStack {
            Text(dateTitle)
                .font(.title3)
                .padding(.vertical)

            ScrollView {
                gridView(
                    types: shownTypes,
                    background: Color.tagBackground,
                    onTapGesture: shownTagTapped,
                    onDrop: onDrop
                )

                gridView(
                    types: hiddenTypes,
                    background: .disable,
                    onTapGesture: hiddenTagTapped
                )

                Toggle(isOn: $use24h) { Text(L10n.MenubarStyle.use24).font(.title3) }
                    .checkboxStyle()
                    .padding(.top)

                Toggle(isOn: $showSeconds) { Text(L10n.MenubarStyle.showSeconds).font(.title3) }
                    .checkboxStyle()
            }
        }
    }

    private func gridView(
        types: [MenubarDateType],
        background: Color,
        onTapGesture: @escaping (MenubarDateType) -> Void,
        onDrop: ((NSItemProvider?, MenubarDateType) -> Bool)? = .none
    ) -> some View {
        LazyVGrid(columns: .init(repeating: .init(), count: 4)) {
            ForEach(types, id: \.self) { type in
                if onDrop != nil {
                    tagView(type, foregroundColor: .white, background: background, onTapGesture: onTapGesture)
                        .onDrag { NSItemProvider(object: type.rawValue as NSString) }
                        .onDrop(of: [.text], isTargeted: .none) {
                            onDrop!($0.first, type)
                        }
                } else {
                    tagView(type, foregroundColor: .white, background: background, onTapGesture: onTapGesture)
                        .onDrag { NSItemProvider(object: type.rawValue as NSString) }
                }
            }
        }
    }

    private func tagView(
        _ type: MenubarDateType,
        foregroundColor: Color,
        background: Color,
        onTapGesture: @escaping (MenubarDateType) -> Void
    ) -> some View {
        Text(transform(locale: locale, type: type))
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .frame(width: 55)
            .padding(5)
            .background(background)
            .appForeground(foregroundColor)
            .clipShape(.capsule)
            .onTapGesture {
                onTapGesture(type)
            }
    }
}

extension DateStyleView {
    func transform(locale: Locale, type: MenubarDateType) -> String {
        switch type {
        case .lm: "正月"
        case .ld: "十五"
        case .sm: locale.inChinese ? "2月" : "Feb"
        case .sd: locale.inChinese ? "5日" : "5"
        case .e: locale.inChinese ? "周日" : "Sun"
        case .a: locale.inChinese ? "下午" : "PM"
        case .t: (use24h ? "20:30" : "8:30") + (showSeconds ? ":30" : "")  // d 24, e sec
        }
    }

    func shownTagTapped(_ type: MenubarDateType) {
        guard shownTypes.count > 1 else { return }
        guard let index = shownTypes.firstIndex(of: type) else { return }
        shownTypes.remove(at: index)
        hiddenTypes.append(type)
    }

    func hiddenTagTapped(_ type: MenubarDateType) {
        guard let index = hiddenTypes.firstIndex(of: type) else { return }
        hiddenTypes.remove(at: index)
        shownTypes.append(type)
    }

    func onDrop(provider: NSItemProvider?, type: MenubarDateType) -> Bool {

        provider?.loadObject(ofClass: NSString.self) { reading, _ in
            guard let typeRawValue = reading as? String else { return }
            Task {
                await onDropAsync(type: type, rawValue: typeRawValue)
            }
        }
        return false
    }

    func onDropAsync(type: MenubarDateType, rawValue: String) async {

        guard let to = shownTypes.firstIndex(of: type) else { return }

        if let from = shownTypes.firstIndex(where: { rawValue == $0.rawValue }) {
            shownTypes.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? (to + 1) : to)
        } else if let from = hiddenTypes.firstIndex(where: { rawValue == $0.rawValue }) {
            let type = hiddenTypes[from]
            shownTypes.insert(type, at: to)
            hiddenTypes.remove(at: from)
        }
    }

}
