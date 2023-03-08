//
//  MainView.swift
//  CalendarX
//
//  Created by zm on 2022/1/26.
//

import SwiftUI


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
        
    }
    
    private func header() -> some View {
        
        HStack {
            MonthYearPicker(date: $viewModel.date, colorScheme: viewModel.colorScheme, tint: viewModel.tint)
            Spacer()
            ScacleImageButton(image: .leftArrow,  action: viewModel.lastMonth)
                .frame(width: .buttonWidth)
            ScacleImageButton(image: .circle, action: viewModel.reset)
                .frame(width: .buttonWidth)
            ScacleImageButton(image: .rightArrow, action: viewModel.nextMonth)
                .frame(width: .buttonWidth)
        }
        
        
    }
    
    private func weekView(date: Date) -> some View {
        Text(L10n.shortWeekday(from: date))
            .foregroundColor(date.inWeekend ? .secondary : .primary)
            .sideLength(30)
    }
    
    @ViewBuilder
    private func dayView(inSameMonth: Bool, day: CalDay) -> some View {
        
        let showHolidays = !day.inNormal && viewModel.showHolidays,
            showEvents = day.events.isNotEmpty && viewModel.showEvents,
            defaultColor: Color = day.inWeekend ? .secondary : .primary
        
        ScacleButton {
            Router.toDate(day)
        } label: {
            ZStack {
                
                if day.inToday {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.accentColor, lineWidth: 1)
                }
                
                if showHolidays {
                    (day.onHoliday ? Color.tagBackground : Color.workdayBackground)
                        .cornerRadius(4)
                    Text(day.stateDesc)
                        .font(.system(size: 7).bold().monospacedDigit())
                        .offset(x: -14, y: -14)
                        .foregroundColor(day.onHoliday ? .accentColor: .secondary)
                }

                if showEvents {
                    Circle()
                        .size(width: 5, height: 5)
                        .foregroundColor(.accentColor)
                        .offset(x: 32, y: 3)
                }
                
                VStack {
                    Text(day.title)
                        .font(.title3.monospacedDigit())
                        .foregroundColor(showHolidays ? day.onHoliday ? .accentColor: defaultColor : defaultColor)
                    if viewModel.showLunar {
                        Text(day.subtitle)
                            .font(.caption2.weight(.regular))
                            .foregroundColor(.secondary)
                    }
                }
                
            }
        }
        .opacity(inSameMonth ? 1:0.3)
        .sideLength(40)
        
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
            Text(L10n.monthSymbol(from: date.month)).font(.title2).foregroundColor(tint)
        } itemLabel: {
            Text(L10n.monthSymbol(from: $0))
        }
        
        ScacleButtonPicker(items: Array(Solar.minYear...Solar.maxYear),
                           tint: tint,
                           colorScheme: colorScheme,
                           selection: $date.year,
                           isPresented: $isPresentedOfYear) {
            Text(date.year.description).font(.title2).foregroundColor(tint)
        } itemLabel: {
            Text(String($0))
        }
        
    }
}

struct CalendarView<Day: View, Header: View, Week: View>: View {
    
    private let date: Date, firstWeekday: CalWeekday, interval: TimeInterval
    
    private let dayView: (Bool, CalDay) -> Day, header: () -> Header, weekView: (Date) -> Week
    
    init(date: Date,
         firstWeekday: CalWeekday,
         interval: TimeInterval,
         @ViewBuilder header: @escaping () -> Header,
         @ViewBuilder weekView: @escaping (Date) -> Week,
         @ViewBuilder dayView: @escaping (Bool, CalDay) -> Day
    ) {
        self.date = date
        self.firstWeekday = firstWeekday
        self.interval = interval
        self.dayView = dayView
        self.header = header
        self.weekView = weekView
    }
    
    private let columns = Array(repeating: GridItem(), count: Solar.daysInWeek)
    
    var body: some View {
        
        let days = makeDays()
        let spacing: CGFloat? = days.count > Solar.minDates ? 1.7: nil
        
        LazyVGrid(columns: columns, spacing: spacing) {
            Section(content: {
                ForEach(0..<min(Solar.daysInWeek, days.count), id: \.self) {
                    weekView(days[$0].date)
                }
                ForEach(days, id: \.id) { day in
                    dayView(date.inSameMonth(as: day.date), day)
                }
            }, header: header)
        }
        
    }
    
    private func makeDays() -> [CalDay]  {
        var calendar = Calendar.gregorian
        calendar.firstWeekday = firstWeekday.rawValue
        let dates = calendar.generateDates(for: date)
        let events = EventHelper.fetchEvents(with: dates.first!, end: dates.last!)
        
        return dates.map { date in
            CalDay(date, events: events.filter{$0.startDate.isSameDay(as: date)})
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
