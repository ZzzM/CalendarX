//
//  SettingsView.swift
//  CalendarX
//
//  Created by zm on 2022/1/26.
//

import SwiftUI
import LaunchAtLogin


struct SettingsView: View {

    var body: some View {
        
        VStack(spacing: 10) {

            titleView()

            Section {
                ThemeRow()
                TintRow()
                WeekdayRow()
                MenuBarStyleRow()
                ScheduleRow()
                LaunchRow()
                VersionRow()
            }.padding(.bottom, 5)

            Section {
                HStack(spacing: 10) {
                    ScacleCapsuleButton(title: L10n.Settings.checkForUpdates, foregroundColor: .white, backgroundColor: .accentColor, action: Updater.checkForUpdates)
                    ScacleCapsuleButton(title: L10n.Settings.quitApp, foregroundColor: .white, backgroundColor: .secondary) { NSApp.terminate(.none) }
                }
            }

        }
    }

    func titleView() -> some View {
        HStack {
            Image.link.hidden()
            Spacer()
            Text(L10n.Settings.title).font(.title2)
            Spacer()
            ScacleImageButton(image: .link) {
                NSWorkspace.open(XLink.gitHub)
            }
        }
    }
    
}


struct ThemeRow: View {

    @EnvironmentObject
    private var pref: Preference

    var body: some View {

        SettingsPickerRow(title: L10n.Settings.theme,
                          items: Theme.allCases,
                          selection: pref.$theme) { Text($0.title) }

//        SettingsPickerRow(title: "Language",
//                          items: Language.allCases,
//                          selection: pref.$language) { Text($0.rawValue) }
    }

}


struct TintRow: View {

    @EnvironmentObject
    private var pref: Preference
    
    var body: some View {
        SettingsPickerRow(title: L10n.Settings.tint,
                          items: Tint.allCases,
                          isGrid: true,
                          selection: pref.$tint) {
            Circle().square(15).foregroundColor(Tint[$0])
        }
    }

}

struct WeekdayRow: View{

    @EnvironmentObject
    private var pref: Preference

    var body: some View {
        SettingsPickerRow(title: L10n.Settings.startWeekOn,
                          items: XWeekday.allCases,
                          selection: pref.$weekday) { Text($0.description) }
    }
}

struct MenuBarStyleRow: View {
    @EnvironmentObject
    private var pref: Preference

    var body: some View {
        SettingsPickerRow(title: L10n.Settings.menuBarStyle,
                          items: MenuBarStyle.allCases,
                          selection: pref.$menuBarStyle) { Text($0.title) }
            .onChange(of: pref.menuBarStyle, notification: .titleStyleDidChanged)
    }
}

struct ScheduleRow: View {

    @EnvironmentObject
    private var pref: Preference

    @State
    private var isAuthorized = Event.isAuthorized

    var body: some View {

        let showSchedule = Binding {
            isAuthorized ? pref.showSchedule : false
        } set: {
            requestAccessToEvent()
            pref.showSchedule = $0
        }

        Toggle(isOn: showSchedule) { Text(L10n.Settings.showSchedule) }
            .checkboxStyle()

    }
    
    func requestAccessToEvent() {
        if Event.isDenied {
            NSWorkspace.openPreference(Privacy.calendars)
        } else {
            Task() {
                isAuthorized = await Event.requestAccess()
            }
        }
    }

}

struct LaunchRow: View {
    var body: some View {
        LaunchAtLogin.Toggle { Text(L10n.Settings.launchAtLogin) }
            .checkboxStyle()
    }
}

struct VersionRow: View {
    var body: some View {
        HStack {
            Text(L10n.Settings.version)
            Spacer()
            Text("\(AppInfo.version) ( \(AppInfo.commitHash) )").font(.subheadline).foregroundColor(.secondary)
        }
    }
}

struct SettingsPickerRow<Item: Hashable, Label: View>: View {

    let title: LocalizedStringKey

    let items: [Item]

    let isGrid: Bool

    @Binding
    var selection: Item

    @ViewBuilder
    let itemLabel: (Item) -> Label

    @State
    private var isPresented = false

    @EnvironmentObject
    private var pref: Preference

    init(title: LocalizedStringKey,
         items: [Item],
         isGrid: Bool = false,
         selection: Binding<Item>,
         @ViewBuilder itemLabel:  @escaping (Item) -> Label) {
        self.title = title
        self.items = items
        self.isGrid = isGrid
        self._selection = selection
        self.itemLabel = itemLabel
    }

    var body: some View {

        HStack {
            Text(title)
            Spacer()
            ScacleButtonPicker(items: items,
                               tint: pref.color,
                               isGrid: isGrid,
                               locale: pref.locale,
                               colorScheme: pref.colorScheme,
                               selection: $selection,
                               isPresented: $isPresented,
                               label: {
                HStack {
                    itemLabel(selection).font(.subheadline).foregroundColor(.secondary)
                    RotationArrow(isPresented: $isPresented)
                }
            }, itemLabel: itemLabel)
        }
    }
}

