import CalendarXLib
import SwiftUI

extension LargeWidget {
    
    struct EntryView: View {
        let entry: Entry
        var calendar: Calendar
        
        private let eventStore = AppEventStore()
        private let festivalStore = FestivalStore()

        private var date: Date { entry.date }
        private var locale: Locale { entry.locale }

        private var accentColor: Color { entry.accentColor }
        private var offBackground: Color { accentColor.opacity(0.12) }

        init(entry: Entry, calendar: Calendar) {
            self.entry = entry
            self.calendar = calendar
            self.calendar.firstWeekday = entry.firstWeekday.rawValue
        }

        var body: some View {
            if #available(macOSApplicationExtension 14.0, *) {
                content.containerBackground(for: .widget) {
                    entry.backgroundColor
                }
            } else {
                ZStack {
                    entry.backgroundColor
                    content.padding()
                }
            }
        }

        private var content: some View {
            let dates = calendar.generateDates(for: date)
            let eventsMap = eventStore.generateEventsMap(dates)
            let spacing: CGFloat? = dates.count > Solar.minDates ? 1.7 : .none

            return LazyVGrid(columns: Solar.gridColumns, spacing: spacing) {
                Section {
                    ForEach(0..<min(Solar.daysInWeek, dates.count), id: \.self) {
                        weekView(dates[$0])
                    }
                    ForEach(dates, id: \.self) { appDate in
                        dayView(appDate, events: eventsMap[appDate.eventsKey] ?? [])
                    }
                } header: {
                    header
                }
            }
        }

        @ViewBuilder
        private func weekView(_ appDate: AppDate) -> some View {
            Text(appDate.shortWeekday(locale: locale))
                .appForeground(appDate.inWeekend ? .appSecondary : .appPrimary)
                .sideLength(30)
        }

        @ViewBuilder
        private func dayView(_ appDate: AppDate, events: [AppEvent]) -> some View {
            
            let tiaoxiu = festivalStore.tiaoxiu(date: appDate)
            let tiaoxiuColor: Color = tiaoxiu.isXiu ? offBackground : .workBackground
            let subtitle = festivalStore.display(date: appDate)
            let showHolidays = !tiaoxiu.isOrdinary && entry.showHolidays
            let showEvents = events.isNotEmpty && entry.showEvents
            let showLunar = entry.showLunar
            let defaultColor: Color = appDate.inWeekend ? .appSecondary : .appPrimary
            let inSameMonth = date.inSameMonth(as: appDate)
            

            ZStack {
                if appDate.inToday {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(accentColor, lineWidth: 1)
                }

                if showHolidays {
                    tiaoxiuColor.clipShape(.rect(cornerRadius: 4))
                    Text(tiaoxiu.description)
                        .font(.system(size: 7, weight: .bold, design: .monospaced))
                        .offset(x: -14, y: -14)
                        .appForeground(tiaoxiu.isXiu ? accentColor : .appSecondary)
                }

                if showEvents {
                    Circle()
                        .size(width: 5, height: 5)
                        .appForeground(accentColor)
                        .offset(x: 32, y: 3)
                }

                VStack {
                    Text(appDate.title)
                        .font(.title3.monospacedDigit())
                        .appForeground(showHolidays ? tiaoxiu.isXiu ? accentColor : defaultColor : defaultColor)
                    if showLunar {
                        Text(subtitle)
                            .font(.caption2.weight(.regular))
                            .appForeground(showHolidays ? tiaoxiu.isXiu ? accentColor : .appSecondary : .appSecondary)
                    }
                }
            }
            .opacity(inSameMonth ? 1 : 0.3)
            .sideLength(40)
        }

        @ViewBuilder
        var header: some View {
            if #available(macOSApplicationExtension 14.0, *) {
                HStack {
                    Button(intent: LastMonthIntent()) {
                        Image.leftArrow
                            .sideLength(.buttonWidth)
                    }

                    Spacer()
                    Button(intent: TodayIntent()) {
                        Text(date.monthSymbol(locale: locale))
                        Text(date.year.description)
                    }
                    Spacer()

                    Button(intent: NextMonthIntent()) {
                        Image.rightArrow
                            .sideLength(.buttonWidth)
                    }
                }
                .font(.title2)
                .buttonStyle(.plain)
                .foregroundStyle(accentColor)
            } else {
                HStack {
                    Text(date.monthSymbol(locale: locale))
                    Text(date.year.description)
                }
                .font(.title2)
                .appForeground(accentColor)
            }
        }
    }
}
