//
//  AppearanceScreen.swift
//  CalendarX
//
//  Created by zm on 2023/2/17.
//

import Algorithms
import CalendarXLib
import SwiftUI

struct AppearanceScreen: View {

    @EnvironmentObject
    private var router: Router

    @EnvironmentObject
    private var appStore: AppStore

    var body: some View {
        VStack(spacing: 10) {
            TitleView {
                Text(L10n.Settings.appearance)
            } leftItems: {
                ScacleImageButton(image: .backward) {
                    router.pop()
                }
            } rightItems: {
                EmptyView()
            }

            themeRow

            if appStore.theme.isNotSystem {
                Picker(selection: $appStore.theme) {
                    ForEach(Theme.allCases.filter(\.isNotSystem), id: \.self) {
                        Text($0.title)
                    }
                } label: {
                    EmptyView()
                }
                .pickerStyle(.segmented)

                switch appStore.theme {
                case .light: lightThemeView
                case .dark: darkThemeView
                default: EmptyView()
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
    }

    private var themeRow: some View {
        let isOn = Binding {
            appStore.theme.isSystem
        } set: { value in
            appStore.theme = value ? .system : NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .vibrantDark]) == .darkAqua ? .dark : .light
        }
        return Toggle(isOn: isOn) { Text(L10n.Theme.system).font(.title3) }
            .checkboxStyle()
    }

    private var lightThemeView: some View {
        ThemeSection(
            selectedAccent: $appStore.appearance.lightAccent,
            selectedBackground: $appStore.appearance.lightBackground,
            accentColors: Bundle.lightAccent,
            backgroundColors: Bundle.lightBackground
        )
    }

    private var darkThemeView: some View {
        ThemeSection(
            selectedAccent: $appStore.appearance.darkAccent,
            selectedBackground: $appStore.appearance.darkBackground,
            accentColors: Bundle.darkAccent,
            backgroundColors: Bundle.darkBackground
        )
    }
}

struct ThemeSection: View {

    @Environment(\.locale)
    private var locale

    @Binding
    var selectedAccent: ColorInfo

    @Binding
    var selectedBackground: ColorInfo

    let accentColors, backgroundColors: [ColorInfo]


    var body: some View {
        section(
            title: L10n.Appearance.accentColor,
            rows: accentColors.chunks(ofCount: 10),
            selectedItem: selectedAccent
        ) { colorInfo in
            Button {
                withAnimation {
                    selectedAccent = colorInfo
                }
            } label: {
                ZStack {
                    Color(hex: colorInfo.hex)
                    if colorInfo == selectedAccent {
                        Image.pin.appForeground(.white)
                    }
                }
            }
        }

        section(
            title: L10n.Appearance.backgroundColor,
            rows: backgroundColors.chunks(ofCount: 10),
            selectedItem: selectedBackground
        ) { colorInfo in
            Button {
                withAnimation {
                    selectedBackground = colorInfo
                }
            } label: {
                ZStack {
                    Color(hex: colorInfo.hex)
                        .shadow(color: .appPrimary, radius: 1, x: 1, y: 1)
                    if colorInfo == selectedBackground {
                        Image.pin.appForeground(.accentColor)
                    }
                }
            }
        }
    }

    private func section(
        title: LocalizedStringKey,
        rows: ChunksOfCountCollection<[ColorInfo]>,
        selectedItem: ColorInfo,
        item: @escaping (ColorInfo) -> some View
    ) -> some View {
        Section {
            VStack(spacing: 0) {
                ForEach(rows, id: \.self) { array in
                    HStack(spacing: 0) {
                        ForEach(array, id: \.self) { colorInfo in
                            item(colorInfo)
                                .frame(height: 26)
                                .buttonStyle(.borderless)
                        }
                    }
                }
            }
            .clipShape(.rect(cornerRadius: 5))
            .shadow(radius: 3, x: 3, y: 3)
            .frame(maxWidth: .infinity, alignment: .leading)

        } header: {
            SettingsRow(
                title: title,
                showArrow: false,
                detail: {
                    if #available(macOS 13.0, *) {
                        Text(selectedItem.name(from: locale)).font(.body.monospaced()).contentTransition(.opacity)
                    } else {
                        Text(selectedItem.name(from: locale)).font(.system(size: 13, design: .monospaced))
                    }
                },
                action: {}
            )
        }
    }
}
