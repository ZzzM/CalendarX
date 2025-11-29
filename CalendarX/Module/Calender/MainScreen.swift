//
//  MainScreen.swift
//  CalendarX
//
//  Created by zm on 2022/1/26.
//

import CalendarXLib
import SwiftUI

struct MainScreen: View {

    @EnvironmentObject
    private var appStore: AppStore

    @EnvironmentObject
    private var calendarStore: CalendarStore

    @EnvironmentObject
    private var router: Router

    @ObservedObject
    var viewModel: MainViewModel

    private var calendar: Calendar {
        viewModel.calendar.firstWeekday = calendarStore.weekday.rawValue
        return viewModel.calendar
    }

    private let eventStore = AppEventStore()

    private let festivalStore = FestivalStore()

    var body: some View {

        CalendarView(
            date: viewModel.date,
            calendar: calendar,
            eventStore: eventStore,
            interval: viewModel.interval,
            showWeekNumbers: calendarStore.showWeekNumbers,
            title: title,
            subtitle: subtitle,
            leading: leading,
            element: element
        )
        .equatable()
        .frame(height: .mainHeight, alignment: .top)
        .padding()
    }

    private func title() -> some View {
        HStack {
            MonthYearPicker(date: $viewModel.date, tint: appStore.accentColor)
                .focusDisabled()

            Spacer()

            if calendarStore.keyboardShortcut {

                KeyboardShortcutButton(key: .leftArrow, action: viewModel.lastMonth)
                KeyboardShortcutButton(key: .space, action: viewModel.reset)
                KeyboardShortcutButton(key: .rightArrow, action: viewModel.nextMonth)
                KeyboardShortcutButton(key: .upArrow, action: viewModel.lastYear)
                KeyboardShortcutButton(key: .downArrow, action: viewModel.nextYear)

            }

            HStack(spacing: calendarStore.showWeekNumbers ? 11.5 : 15.5) {

                ScacleImageButton(image: .leftArrow, action: viewModel.lastMonth)
                    .frame(width: 30)
                ScacleImageButton(image: .circle, action: viewModel.reset)
                    .frame(width: 30)
                ScacleImageButton(image: .rightArrow, action: viewModel.nextMonth)
                    .frame(width: 30)

            }
        }
    }

    private func subtitle(_ dates: [AppDate]) -> some View {
        ForEach(dates, id: \.self) {
            Text($0.shortWeekday(locale: appStore.locale))
                .appForeground($0.inWeekend ? .appSecondary : .appPrimary)
                .sideLength(30)
        }
    }

    private func leading(_ dates: [AppDate], spacing: CGFloat) -> some View {
        VStack(spacing: spacing) {
            Text("#")
                .frame(width: 15, height: 30)
                .appForeground(.accentColor)
            ForEach(dates, id: \.self) {
                Text($0.weekOfYearString(calendar: calendar))
                    .font(.system(size: 7, weight: .bold))
                    .frame(width: 15, height: 40)
                    .appForeground(.accentColor)
            }
        }
    }

    @ViewBuilder
    private func element(_ appDate: AppDate, events: [AppEvent]) -> some View {

        let tiaoxiu = festivalStore.tiaoxiu(date: appDate)
        let tiaoxiuColor: Color = tiaoxiu.isXiu ? .offBackground : .workBackground
        let subtitle = festivalStore.display(date: appDate)
        let showHolidays = !tiaoxiu.isOrdinary && calendarStore.showHolidays
        let showEvents = events.isNotEmpty && calendarStore.showEvents
        let showLunar = calendarStore.showLunar
        let defaultColor: Color = appDate.inWeekend ? .appSecondary : .appPrimary
        let inSameMonth = viewModel.date.inSameMonth(as: appDate)

        ScacleButton {
            let festivals = festivalStore.all(date: appDate)
            router.push(.date(appDate, events, festivals, calendar))
        } label: {
            ZStack {
                if appDate.inToday {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.accentColor, lineWidth: 1)
                }

                if showHolidays {
                    tiaoxiuColor.clipShape(.rect(cornerRadius: 4))
                    Text(tiaoxiu.description)
                        .font(.system(size: 7, weight: .bold, design: .monospaced))
                        .offset(x: -14, y: -14)
                        .appForeground(tiaoxiu.isXiu ? .accentColor : .appSecondary)
                }

                if showEvents {
                    Circle()
                        .size(width: 5, height: 5)
                        .appForeground(.accentColor)
                        .offset(x: 32, y: 3)
                }

                VStack {
                    Text(appDate.title)
                        .font(.title3.monospacedDigit())
                        .appForeground(showHolidays ? tiaoxiu.isXiu ? .accentColor : defaultColor : defaultColor)
                    if showLunar {
                        Text(subtitle)
                            .font(.caption2.weight(.regular))
                            .appForeground(showHolidays ? tiaoxiu.isXiu ? .accentColor : .appSecondary : .appSecondary)
                    }
                }
            }
            .opacity(inSameMonth ? 1 : 0.3)
            .sideLength(40)
        }
    }
}

struct MonthYearPicker: View {

    @Environment(\.locale)
    private var locale

    @Binding
    var date: Date

    let tint: Color

    @State
    private var isPresentedOfMonth = false

    @State
    private var isPresentedOfYear = false

    var body: some View {
        ScacleButtonPicker(
            items: Array(Solar.minMonth...Solar.maxMonth),
            tint: tint,
            selection: $date.month,
            isPresented: $isPresentedOfMonth
        ) {
            Text(date.monthSymbol(locale: locale)).font(.title2).appForeground(tint)
        } itemLabel: {
            Text(date.monthSymbol(index: $0, locale: locale))
        }

        ScacleButtonPicker(
            items: Array(Solar.minYear...Solar.maxYear),
            tint: tint,
            selection: $date.year,
            isPresented: $isPresentedOfYear
        ) {
            Text(date.year.description).font(.title2).appForeground(tint)
        } itemLabel: {
            Text(String($0))
        }
    }
}

struct CalendarView<Title: View, Subtitle: View, Leading: View, Element: View>: View {

    private let date: AppDate, calendar: Calendar, eventStore: AppEventStore, interval: TimeInterval

    private let showWeekNumbers: Bool

    private let title: () -> Title
    private let subtitle: ([AppDate]) -> Subtitle
    private let leading: ([AppDate], CGFloat) -> Leading
    private let element: (AppDate, [AppEvent]) -> Element

    init(
        date: AppDate,
        calendar: Calendar,
        eventStore: AppEventStore,
        interval: TimeInterval,
        showWeekNumbers: Bool,
        @ViewBuilder title: @escaping () -> Title,
        @ViewBuilder subtitle: @escaping ([AppDate]) -> Subtitle,
        @ViewBuilder leading: @escaping ([AppDate], CGFloat) -> Leading,
        @ViewBuilder element: @escaping (AppDate, [AppEvent]) -> Element
    ) {
        self.date = date
        self.calendar = calendar
        self.eventStore = eventStore
        self.interval = interval

        self.showWeekNumbers = showWeekNumbers
        self.title = title
        self.subtitle = subtitle
        self.leading = leading
        self.element = element
    }

    var body: some View {
        let dates = calendar.generateDates(for: date)
        let spacing = dates.count > Solar.minDates ? 0.5 : 8.5
        let eventsMap = eventStore.generateEventsMap(dates)

        let leadingDates = dates.striding(by: Solar.daysInWeek).map(\.self)
        let subtitleDates = dates.prefix(Solar.daysInWeek).map(\.self)
        let columns = Array(
            repeating: GridItem(.fixed(30), spacing: showWeekNumbers ? 11.5 : 15.5),
            count: Solar.daysInWeek
        )

        VStack {

            title()

            LazyHStack {

                if showWeekNumbers {
                    leading(leadingDates, spacing)
                }

                LazyVGrid(columns: columns, spacing: spacing) {

                    subtitle(subtitleDates)

                    ForEach(dates, id: \.self) { appDate in
                        element(appDate, eventsMap[appDate.eventsKey] ?? [])
                    }
                }

            }

        }

    }
}

extension CalendarView: @preconcurrency Equatable {

    static func == (lhs: CalendarView<Title, Subtitle, Leading, Element>, rhs: CalendarView<Title, Subtitle, Leading, Element>)
        -> Bool
    {
        lhs.date.year == rhs.date.year
            && lhs.date.month == rhs.date.month
            && lhs.date.day == rhs.date.day
            && lhs.interval == rhs.interval
    }
}
