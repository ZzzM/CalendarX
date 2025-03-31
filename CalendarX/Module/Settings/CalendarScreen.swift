//
//  CalendarScreen.swift
//  CalendarX
//
//  Created by zm on 2023/2/26.
//

import CalendarXLib
import SwiftUI

@MainActor
struct CalendarScreen: View {

    @Environment(\.locale)
    private var locale

    @Environment(\.authorizer)
    private var authorizer

    @EnvironmentObject
    private var router: Router

    @EnvironmentObject
    private var dialog: Dialog

    @EnvironmentObject
    private var calendarStore: CalendarStore


    var body: some View {
        VStack(spacing: 20) {
            TitleView {
                Text(L10n.Settings.calendar)
            } leftItems: {
                ScacleImageButton(image: .backward) {
                    router.pop()
                }
            } rightItems: {
                EmptyView()
            }

            Section {
                weekRow
                eventsRow
                lunarRow
                holidaysRow
                weekNumbersRow
                keyboardShortcutRow
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
    }
}

extension CalendarScreen {

    private var weekRow: some View {
        SettingsPickerRow(
            title: L10n.Calendar.startWeekOn,
            items: AppWeekday.allCases,
            selection: calendarStore.$weekday
        ) { Text($0.symbol(locale: locale)) }
    }

    @ViewBuilder
    private var eventsRow: some View {

        let isOn = Binding {
            calendarStore.showEvents
        } set: { value in
            switch authorizer.eventsStatus {
            case .notRequested: Task { calendarStore.showEvents = await authorizer.requestEventsAuthorization() }
            case .granted: calendarStore.showEvents = value
            default:
                dialog.popup(.calendars) {
                    router.preference(Privacy.calendars)
                }
            }
        }

        Toggle(isOn: isOn) { Text(L10n.Calendar.showEvents).font(.title3) }
            .checkboxStyle()
    }

    private var lunarRow: some View {
        Toggle(isOn: calendarStore.$showLunar) { Text(L10n.Calendar.showLunar).font(.title3) }
            .checkboxStyle()
    }

    private var holidaysRow: some View {
        Toggle(isOn: calendarStore.$showHolidays) { Text(L10n.Calendar.showHolidays).font(.title3) }
            .checkboxStyle()
    }

    private var weekNumbersRow: some View {
        Toggle(isOn: calendarStore.$showWeekNumbers) { Text(L10n.Calendar.showWeekNumbers).font(.title3) }
            .checkboxStyle()
    }
    
    private var keyboardShortcutRow: some View {
        Toggle(isOn: calendarStore.$keyboardShortcut) {
            HStack {
                Text(L10n.Calendar.keyboardShortcut).font(.title3)
                ScacleImageButton(image: .tips) {
                    dialog.popup(.shortcut)
                }
            }
        }
        .checkboxStyle()
    }
}
