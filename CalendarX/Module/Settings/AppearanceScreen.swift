//
//  AppearanceScreen.swift
//  CalendarX
//
//  Created by zm on 2023/2/17.
//

import SwiftUI
import CalendarXShared
import Algorithms

struct AppearanceScreen: View {

    @ObservedObject
    var viewModel: SettingsViewModel

    var body: some View {


        VStack(spacing: 10) {

            TitleView {
                Text(L10n.Settings.appearance)
            } leftItems: {
                ScacleImageButton(image: .backward, action: Router.back)
            } rightItems: {
                EmptyView()
            }

            themeRow

            if !viewModel.isSystemTheme {
                Picker(selection: $viewModel.theme) {
                    ForEach(Theme.allCases.filter{ $0 != .system }, id: \.self) {
                        Text($0.title)
                    }
                } label: {
                    EmptyView()
                }
                .pickerStyle(.segmented)

                switch viewModel.theme {
                case .light: lightThemeView
                case .dark: darkThemeView
                default: EmptyView()
                }
            }

        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()

    }

    private  var themeRow: some View {
        Toggle(isOn: $viewModel.isSystemTheme) { Text(L10n.Theme.system).font(.title3) }
            .checkboxStyle()
    }

    private var lightThemeView: some View {
        ThemeSection(viewModel: viewModel, isDarkTheme: false)
    }

    private var darkThemeView: some View {
        ThemeSection(viewModel: viewModel, isDarkTheme: true)
    }

}

struct ThemeSection: View {

    @ObservedObject
    var viewModel: SettingsViewModel

    let isDarkTheme: Bool

    private let accentColors, backgroundColors: [ColorInfo]

    @State
    private var selectedAccent: ColorInfo {
        didSet {
            if isDarkTheme {
                viewModel.appearance.darkAccent = selectedAccent
            } else {
                viewModel.appearance.lightAccent = selectedAccent
            }
        }
    }

    @State
    private var selectedBackground: ColorInfo {
        didSet {
            if isDarkTheme {
                viewModel.appearance.darkBackground = selectedBackground
            } else {
                viewModel.appearance.lightBackground = selectedBackground
            }
        }
    }

    init(viewModel: SettingsViewModel, isDarkTheme: Bool) {
        self.viewModel = viewModel
        self.isDarkTheme = isDarkTheme
        accentColors = isDarkTheme ? Bundle.darkAccent: Bundle.lightAccent
        backgroundColors = isDarkTheme ? Bundle.darkBackground: Bundle.lightBackground

        let appearance = viewModel.appearance
        self.selectedAccent =  isDarkTheme ? appearance.darkAccent: appearance.lightAccent
        self.selectedBackground = isDarkTheme ? appearance.darkBackground: appearance.lightBackground
    }


    var body: some View {

        section(title:  L10n.Appearance.accentColor,
                rows: accentColors.chunks(ofCount: 10),
                selectedItem: selectedAccent) { colorInfo in
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

        section(title:  L10n.Appearance.backgroundColor,
                rows: backgroundColors.chunks(ofCount: 10),
                selectedItem: selectedBackground) { colorInfo in
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

    private func section(title: LocalizedStringKey, 
                         rows: ChunksOfCountCollection<[ColorInfo]>,
                         selectedItem: ColorInfo,
                         item:  @escaping (ColorInfo) -> some View ) -> some View {

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
            SettingsRow(title: title, showArrow: false, detail: {
                if #available(macOS 13.0, *) {
                    Text(selectedItem.name).font(.body.monospaced()).contentTransition(.opacity)
                } else {
                    Text(selectedItem.name).font(.system(size: 13, design: .monospaced))
                }
            }, action: {})
        }
    }

}

