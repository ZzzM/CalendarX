//
//  MainView.swift
//  CalendarX
//
//  Created by zm on 2022/1/26.
//

import SwiftUI
import CalendarXShared

struct MainView: View {

    @ObservedObject
    var viewModel: MainViewModel

    var body: some View {

        CalendarView(date: viewModel.date,
                     firstWeekday: viewModel.weekday,
                     interval: viewModel.interval,
                     header: header,
                     weekView: weekView,
                     dayView: dayView)
        .equatable()
        .frame(height: .mainHeight)
        .padding()
    }
    
    private func header() -> some View {
        
        HStack {
            MonthYearPicker(date: $viewModel.date, colorScheme: viewModel.colorScheme, tint: viewModel.tint)

            Spacer()


            if viewModel.keyboardShortcut {
                Group {
                    Button(action: viewModel.lastMonth) { }.keyboardShortcut(.leftArrow, modifiers: [])
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
    
    private func weekView(date: Date) -> some View {
        Text(L10n.shortWeekday(from: date))
            .appForeground(date.inWeekend ? .appSecondary : .appPrimary)
            .sideLength(30)
    }
    
    @ViewBuilder
    private func dayView(appDate: AppDate) -> some View {

        let showHolidays = !appDate.inNormal && viewModel.showHolidays,
            showEvents = appDate.events.isNotEmpty && viewModel.showEvents,
            showLunar = viewModel.showLunar,
            defaultColor: Color = appDate.inWeekend ? .appSecondary : .appPrimary,
            inSameMonth = viewModel.date.inSameMonth(as: appDate.date),
            txColor: Color = appDate.onHoliday ? .offBackground : .workBackground

        ScacleButton {
            Router.toDate(appDate)
        } label: {
            ZStack {

                if appDate.inToday {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.accentColor, lineWidth: 1)
                }
                
                if showHolidays {
                    txColor.clipShape(.rect(cornerRadius: 4))
                    Text(appDate.stateDesc)
                        .font(.system(size: 7, weight: .bold, design: .monospaced))
                        .offset(x: -14, y: -14)
                        .appForeground(appDate.onHoliday ? .accentColor: .appSecondary)
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
                        .appForeground(showHolidays ? appDate.onHoliday ? .accentColor: defaultColor : defaultColor)
                    if showLunar {
                        Text(appDate.subtitle)
                            .font(.caption2.weight(.regular))
                            .appForeground(showHolidays ? appDate.onHoliday ? .accentColor: .appSecondary : .appSecondary)
                    }
                }
                
            }
            .opacity(inSameMonth ? 1:0.3)
            .sideLength(40)
        }

        
    }
}

struct MonthYearPicker: View {
    
    @Binding
    var date: Date

    let colorScheme: ColorScheme?, tint: Color
    
    @State
    private var isPresentedOfMonth = false
    
    @State
    private var isPresentedOfYear = false

    var body: some View {
        
        ScacleButtonPicker(items: Array(Solar.minMonth...Solar.maxMonth),
                           tint: tint,
                           colorScheme: colorScheme,
                           selection: $date.month,
                           isPresented: $isPresentedOfMonth) {
            Text(L10n.monthSymbol(from: date.month)).font(.title2).appForeground(tint)
        } itemLabel: {
            Text(L10n.monthSymbol(from: $0))
        }
        
        ScacleButtonPicker(items: Array(Solar.minYear...Solar.maxYear),
                           tint: tint,
                           colorScheme: colorScheme,
                           selection: $date.year,
                           isPresented: $isPresentedOfYear) {
            Text(date.year.description).font(.title2).appForeground(tint)
        } itemLabel: {
            Text(String($0))
        }
        
    }
}

struct CalendarView<Day: View, Header: View, Week: View>: View {
    
    private let date: Date, firstWeekday: AppWeekday, interval: TimeInterval

    private let dayView: (AppDate) -> Day, header: () -> Header, weekView: (Date) -> Week

    init(date: Date,
         firstWeekday: AppWeekday,
         interval: TimeInterval,
         @ViewBuilder header: @escaping () -> Header,
         @ViewBuilder weekView: @escaping (Date) -> Week,
         @ViewBuilder dayView: @escaping (AppDate) -> Day
    ) {
        self.date = date
        self.firstWeekday = firstWeekday
        self.interval = interval
        self.dayView = dayView
        self.header = header
        self.weekView = weekView
    }

    var body: some View {
        
        let dates = CalendarHelper.makeDates(firstWeekday: firstWeekday, date: date)
        let columns = CalendarHelper.columns
        let spacing = CalendarHelper.spacing(from: dates.count)

        LazyVGrid(columns: columns, spacing: spacing) {
            Section {
                ForEach(0..<min(Solar.daysInWeek, dates.count), id: \.self) {
                    weekView(dates[$0].date)
                }
                ForEach(dates, id: \.id) { appDate in
                    dayView(appDate)
                }
            } header: {
                header()
            }
        }
        
    }

}

extension CalendarView: Equatable {
    static func == (lhs: CalendarView<Day, Header, Week>, rhs: CalendarView<Day, Header, Week>) -> Bool {
        lhs.date.year == rhs.date.year &&
        lhs.date.month == rhs.date.month &&
        lhs.interval == rhs.interval
    }
}
