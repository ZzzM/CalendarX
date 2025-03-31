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

    
    private var isDark: Bool {
        NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .vibrantDark]) == .darkAqua
    }
    
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

            SegmentedPicker(items: Theme.allCases,
                            selection: $appStore.theme) {
                Text($0.title)
            }
            
            switch appStore.theme {
            case .light: lightThemeView
            case .dark: darkThemeView
            default: deviceThemeView
            }
            
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
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
    
    @ViewBuilder
    private var deviceThemeView: some View {
        if isDark {
            darkThemeView
        } else {
            lightThemeView
        }
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
                selectedAccent = colorInfo
            } label: {
                ZStack {
                    Color(hex: colorInfo.hex)
                    if colorInfo == selectedAccent {
                        Image.pin.appForeground(.appWhite)
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
                selectedBackground = colorInfo
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
                    Text(selectedItem.name(from: locale))
                        .font(.footnote)
                },
                action: {}
            )
        }
    }
}
