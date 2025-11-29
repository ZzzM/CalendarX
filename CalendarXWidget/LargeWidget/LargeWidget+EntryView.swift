import Algorithms
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

        @ViewBuilder
        private var content: some View {
            let dates = calendar.generateDates(for: date)

            let showWeekNumbers = entry.showWeekNumbers

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
                        leading(leadingDates, spacing: spacing)
                    }

                    LazyVGrid(columns: columns, spacing: spacing) {

                        subtitle(subtitleDates)

                        ForEach(dates, id: \.self) { appDate in
                            element(appDate, events: eventsMap[appDate.eventsKey] ?? [])
                        }
                    }

                }

            }
        }

        private func subtitle(_ dates: [AppDate]) -> some View {
            ForEach(dates, id: \.self) {
                Text($0.shortWeekday(locale: locale))
                    .appForeground($0.inWeekend ? .appSecondary : .appPrimary)
                    .sideLength(30)
            }
        }

        private func leading(_ dates: [AppDate], spacing: CGFloat) -> some View {
            VStack(spacing: spacing) {
                Text("#")
                    .frame(width: 15, height: 30)
                    .appForeground(accentColor)
                ForEach(dates, id: \.self) {
                    Text($0.weekOfYearString(calendar: calendar))
                        .font(.system(size: 7, weight: .bold))
                        .frame(width: 15, height: 40)
                        .appForeground(accentColor)
                }
            }
        }

        @ViewBuilder
        private func element(_ appDate: AppDate, events: [AppEvent]) -> some View {

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
        private func title() -> some View {
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
