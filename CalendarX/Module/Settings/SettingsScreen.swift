//
//  SettingsScreen.swift
//  CalendarX
//
//  Created by zm on 2022/1/26.
//

import CalendarXLib
import SwiftUI

@MainActor
struct SettingsScreen: View {

    @EnvironmentObject
    private var router: Router

    @EnvironmentObject
    private var dialog: Dialog
    
    @EnvironmentObject
    private var appStore: AppStore
    
    @EnvironmentObject
    private var menubarStore: MenubarStore

    @Environment(\.authorizer)
    private var authorizer

    private let updater: Updater

    @State
    private var automaticallyChecksForUpdates: Bool {
        didSet {
            updater.automaticallyChecksForUpdates = automaticallyChecksForUpdates
        }
    }

    init(updater: Updater) {

        self.automaticallyChecksForUpdates = updater.automaticallyChecksForUpdates
        self.updater = updater

    }

    var body: some View {
        VStack(spacing: 15) {
            TitleView {
                Text(L10n.Settings.title).onTapGesture {
                    router.pop()
                }
            } leftItems: {
                EmptyView()
            } rightItems: {
                ScacleImageButton(image: .quit) {
                    dialog.popup(.exit) {
                        router.exit()
                    }
                }
                .focusDisabled()
            }

            Section {
                appearanceRow
                calendarRow
                languageRow
                memubarRow
                autoRow
                launchRow
                recommendRow
                aboutRow
            }
        }
        .frame(height: .mainHeight, alignment: .top)
        .padding()

    }
}

extension SettingsScreen {
    var appearanceRow: some View {
        SettingsRow(title: L10n.Settings.appearance, detail: {}) {
            router.push(.appearanceSettings)
        }
    }

    var calendarRow: some View {
        SettingsRow(title: L10n.Settings.calendar, detail: {}) {
            router.push(.calendarSettings)
        }
    }

    var languageRow: some View {
        SettingsPickerRow(
            title: L10n.Settings.language,
            items: Language.allCases,
            width: 70,
            selection: $appStore.language
        ) { Text($0.title) }
    }

    var memubarRow: some View {
        SettingsRow(
            title: L10n.Settings.menubarStyle,
            detail: { Text(menubarStore.style.title) }
        ) {
            router.push(.menubarSettings)
        }
    }

    var launchRow: some View {
        AppToggle { Text(L10n.Settings.launchAtLogin).font(.title3) }
            .checkboxStyle()
    }

    @ViewBuilder
    var autoRow: some View {

        let isOn = Binding {
            automaticallyChecksForUpdates
        } set: { value in
            Task {
                switch await authorizer.notificationsuStatus {
                case .denied:
                    dialog.popup(.notifications) {
                        router.preference(Privacy.notifications)
                    }
                case .notRequested:
                    automaticallyChecksForUpdates = await authorizer.requestNotificationsAuthorization()
                default:
                    automaticallyChecksForUpdates = value
                }
            }
        }

        Toggle(isOn: isOn) { Text(L10n.Settings.auto).font(.title3) }
            .checkboxStyle()
            .onAppear {
                Task {
                    if await authorizer.allowNotifications { return }
                    if automaticallyChecksForUpdates {
                        automaticallyChecksForUpdates.toggle()
                    }
                }
            }

    }

    var recommendRow: some View {
        SettingsRow(title: L10n.Settings.recommendations, detail: {}) {
            router.push(.recommendations)
        }
    }

    var aboutRow: some View {
        SettingsRow(title: L10n.Settings.about, detail: {}) {
            router.push(.about)
        }
    }
}

struct SettingsRow<Content: View>: View {
    let title: LocalizedStringKey, titleFont: Font, showArrow: Bool

    @ViewBuilder
    let detail: () -> Content

    let action: VoidClosure

    init(
        title: LocalizedStringKey,
        titleFont: Font = .title3,
        showArrow: Bool = true,
        @ViewBuilder detail: @escaping () -> Content,
        action: @escaping VoidClosure
    ) {
        self.title = title
        self.titleFont = titleFont
        self.showArrow = showArrow
        self.detail = detail
        self.action = action
    }

    var body: some View {
        HStack {
            Text(title)
                .font(titleFont)
            Spacer()

            Group {
                detail()
                if showArrow {
                    Image.rightArrow.font(titleFont)
                }
            }
            .appForeground(.appSecondary)
        }
        .contentShape(.rect)
        .onTapGesture(perform: action)
    }
}

struct SettingsPickerRow<Item: Hashable, Label: View>: View {
    let title: LocalizedStringKey, items: [Item], width: CGFloat

    @Binding
    var selection: Item

    @ViewBuilder
    let itemLabel: (Item) -> Label

    @State
    private var isPresented = false

    @EnvironmentObject
    private var appStore: AppStore
    
    init(
        title: LocalizedStringKey,
        items: [Item],
        width: CGFloat = .popoverWidth,
        selection: Binding<Item>,
        @ViewBuilder itemLabel: @escaping (Item) -> Label
    ) {
        self.title = title
        self.items = items
        self.width = width
        self._selection = selection
        self.itemLabel = itemLabel
    }

    var body: some View {
        HStack {
            Text(title).font(.title3)
            Spacer()
            ScacleButtonPicker(
                items: items,
                tint: appStore.accentColor,
                width: width,
                selection: $selection,
                isPresented: $isPresented,
                label: {
                    HStack {
                        itemLabel(selection).appForeground(.appSecondary)
                        RotationArrow(isPresented: $isPresented)
                    }
                },
                itemLabel: itemLabel
            )
        }
    }
}
