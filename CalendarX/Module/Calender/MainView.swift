//
//  MainView.swift
//  CalendarX
//
//  Created by zm on 2022/1/26.
//

import SwiftUI


struct MainView: View {

    private let weekday = Preference.shared.weekday

    private let showSchedule = Preference.shared.showSchedule

    @StateObject
    private var viewModel = MainViewModel()

    @State
    private var isShown = false

    @State
    private var selectedDay: XDay!

    var body: some View {

        ZStack {
            if isShown {
                DateView(isShown: $isShown, day: selectedDay).height(.mainHeight).transition(.move(edge: .bottom))
            }
            CalendarView(date: viewModel.date,
                         firstWeekday: weekday,
                         timestamp: viewModel.timestamp,
                         header: header,
                         weekView: weekView,
                         dayView: dayView)
            .equatable()
            .opacity(isShown ? 0:1)
            .height(.mainHeight)
        }

    }
    
    private func header() -> some View {

        HStack {
            MonthYearPicker(date: $viewModel.date)
            Spacer()
            ScacleImageButton(image: .leftArrow, action: viewModel.lastMonth).width(.buttonWidth)
            ScacleImageButton(image: .circle, action: viewModel.today).width(.buttonWidth)
            ScacleImageButton(image: .rightArrow, action: viewModel.nextMonth).width(.buttonWidth)
        }


    }

    private func weekView(date: Date) -> some View {
        Text(L10n.shortWeekday(from: date))
            .foregroundColor(date.inWeekend ? .secondary : .primary)
            .square(30)
    }

    private func dayView(inSameMonth: Bool, day: XDay) -> some View {
        ScacleButton {
            withAnimation() {
                isShown.toggle()
                selectedDay = day
            }
        } label: {
            ZStack {

                if day.inToday {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.accentColor, lineWidth: 1)
                }

                if day.inWorking {
                    Color.workdayBackground.cornerRadius(4)
                    Text(day.stateDesc)
                        .font(.system(size: 6)).offset(x: -14, y: -14)
                        .foregroundColor(.secondary)
                }
                if day.onHoliday {
                    Color.accentColor.opacity(0.1).cornerRadius(4)
                    Text(day.stateDesc)
                        .font(.system(size: 6)).offset(x: -14, y: -14)
                        .foregroundColor(.accentColor)
                }

                if day.events.isNotEmpty, showSchedule {
                    Circle()
                        .size(width: 5, height: 5)
                        .foregroundColor(.accentColor)
                        .offset(x: 32, y: 3)
                }

                VStack {
                    Text(day.title)
                        .font(.title3)
                        .foregroundColor(day.onHoliday ? .accentColor: day.inWeekend ? .secondary : .primary)
                    Text(day.subtitle)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

            }
        }
        .opacity(inSameMonth ? 1:0.3)
        .square(40)

    }
}

struct MonthYearPicker: View {
    
    @Binding
    var date: Date

    private let pref = Preference.shared

    @State
    private var isPresentedOfMonth = false

    @State
    private var isPresentedOfYear = false


    var body: some View {

        let colorScheme = pref.colorScheme, tint = pref.color

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

    private let date: Date, firstWeekday: XWeekday, timestamp: TimeInterval

    private let dayView: (Bool, XDay) -> Day, header: () -> Header, weekView: (Date) -> Week

    init(date: Date,
         firstWeekday: XWeekday,
         timestamp: TimeInterval,
         @ViewBuilder header: @escaping () -> Header,
         @ViewBuilder weekView: @escaping (Date) -> Week,
         @ViewBuilder dayView: @escaping (Bool, XDay) -> Day
    ) {
        self.date = date
        self.firstWeekday = firstWeekday
        self.timestamp = timestamp
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

    private func makeDays() -> [XDay]  {
        var calendar = Calendar.gregorian
        calendar.firstWeekday = firstWeekday.rawValue
        let dates = calendar.generateDates(for: date)
        let events = Event.fetchEvents(with: dates.first!, end: dates.last!)
        return dates.map { date in
            XDay(date, events: events.filter{$0.startDate.isSameDay(as: date)})
        }
    }
}

extension CalendarView: Equatable {
    static func == (lhs: CalendarView<Day, Header, Week>, rhs: CalendarView<Day, Header, Week>) -> Bool {
        lhs.firstWeekday == rhs.firstWeekday &&
        lhs.date == rhs.date &&
        lhs.timestamp == rhs.timestamp
    }
}
