//
//  SettingsView.swift
//  CalendarX
//
//  Created by zm on 2022/1/26.
//

import SwiftUI
import LaunchAtLogin


struct SettingsView: View {


    @State
    private var isShown = false
    

    var body: some View {

        ZStack {
            if isShown {
                MenuBarSettingsView(isShown: $isShown)
                    .transition(.move(edge: .bottom))
            }
            settingsView()
                .opacity(isShown ? 0:1)
        }


    }

    func settingsView() -> some View {

        VStack(spacing: 10) {

            titleView()

            Section {
                ThemeRow()
                TintRow()
                WeekdayRow()
                MenuBarStyleRow(isShown: $isShown)
                ScheduleRow()
                LaunchRow()
            }.padding(.bottom, 3)

            Section {
                LastRow()
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


    @Binding
    var isShown: Bool

    @EnvironmentObject
    private var pref: Preference


    var body: some View {
        HStack {
            Text(L10n.Settings.menuBarStyle).font(.title3)
            Spacer()
            ScacleButton {
                withAnimation() {
                    isShown.toggle()
                }
            } label: {
                HStack {
                    Text(pref.menuBarStyle.title)
                    Image.rightArrow
                }.foregroundColor(.secondary)
            }
        }
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

        Toggle(isOn: showSchedule) { Text(L10n.Settings.showSchedule).font(.title3) }
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
        LaunchAtLogin.Toggle { Text(L10n.Settings.launchAtLogin).font(.title3) }
            .checkboxStyle()
    }
}

struct LastRow: View {


    var body: some View {
        HStack(spacing: 10) {

            ScacleCapsuleButton(title: L10n.Settings.quitApp, foregroundColor: .white, backgroundColor: .secondary) { NSApp.terminate(.none) }

            ScacleCapsuleButton(title: L10n.Settings.checkForUpdates, foregroundColor: .white, backgroundColor: .accentColor, action: Updater.checkForUpdates)

        }

        Text("\(AppInfo.version) ( \(AppInfo.commitHash) )")
            .font(.footnote)
            .foregroundColor(.secondary)
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
            Text(title).font(.title3)
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
                    itemLabel(selection).foregroundColor(.secondary)
                    RotationArrow(isPresented: $isPresented)
                }
            }, itemLabel: itemLabel)
        }
    }
}

