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
            header: header,
            weekView: weekView,
            dayView: dayView
        )
        .equatable()
        .frame(height: .mainHeight)
        .padding()
    }

    private func header() -> some View {
        HStack {
            MonthYearPicker(date: $viewModel.date, tint: appStore.accentColor)
                .focusDisabled()

            Spacer()

            if calendarStore.keyboardShortcut {
                Group {
                    Button(action: viewModel.lastMonth) {}.keyboardShortcut(.leftArrow, modifiers: [])
                    Button(action: viewModel.reset) {}.keyboardShortcut(.space, modifiers: [])
                    Button(action: viewModel.nextMonth) {}.keyboardShortcut(.rightArrow, modifiers: [])
                    Button(action: viewModel.lastYear) {}.keyboardShortcut(.upArrow, modifiers: [])
                    Button(action: viewModel.nextYear) {}.keyboardShortcut(.downArrow, modifiers: [])
                }
                .buttonStyle(.borderless)
            }

            Group {
                ScacleImageButton(image: .leftArrow, action: viewModel.lastMonth)
                ScacleImageButton(image: .circle, action: viewModel.reset)
                ScacleImageButton(image: .rightArrow, action: viewModel.nextMonth)
            }
            .frame(width: .buttonWidth)
        }
    }

    private func weekView(_ appDate: AppDate) -> some View {
        Text(appDate.shortWeekday(locale: appStore.locale))
            .appForeground(appDate.inWeekend ? .appSecondary : .appPrimary)
            .sideLength(30)
    }

    @ViewBuilder
    private func dayView(_ appDate: AppDate, events: [AppEvent]) -> some View {
        
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
            router.push(.date(appDate, events, festivals))
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

struct CalendarView<Day: View, Header: View, Week: View>: View {
    
    private let date: Date, calendar: Calendar, eventStore: AppEventStore, interval: TimeInterval

    private let dayView: (AppDate, [AppEvent]) -> Day, header: () -> Header, weekView: (Date) -> Week
    
    init(
        date: Date,
        calendar: Calendar,
        eventStore: AppEventStore,
        interval: TimeInterval,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder weekView: @escaping (Date) -> Week,
        @ViewBuilder dayView: @escaping (AppDate, [AppEvent]) -> Day
    ) {
        self.date = date
        self.calendar = calendar
        self.eventStore = eventStore
        self.interval = interval
        self.dayView = dayView
        self.header = header
        self.weekView = weekView
    }

    var body: some View {
        let dates = calendar.generateDates(for: date)
        let spacing: CGFloat? = dates.count > Solar.minDates ? 1.7 : .none
        let eventsMap = eventStore.generateEventsMap(dates)

        LazyVGrid(columns: Solar.gridColumns, spacing: spacing) {
            Section {
                ForEach(0..<min(Solar.daysInWeek, dates.count), id: \.self) {
                    weekView(dates[$0])
                }
                ForEach(dates, id: \.self) { appDate in
                    dayView(appDate, eventsMap[appDate.eventsKey] ?? [])
                }
            } header: {
                header()
            }
        }
    }
}

extension CalendarView: @preconcurrency Equatable {

    static func == (lhs: CalendarView<Day, Header, Week>, rhs: CalendarView<Day, Header, Week>) -> Bool {
        lhs.date.year == rhs.date.year && lhs.date.month == rhs.date.month && lhs.date.day == rhs.date.day
            && lhs.interval == rhs.interval
    }
}
