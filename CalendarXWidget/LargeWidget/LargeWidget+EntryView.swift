import SwiftUI
import CalendarXShared

extension LargeWidget {
    struct EntryView: View {

        let entry: Entry

        private var date: Date { entry.date }
        private var locale: Locale { entry.locale }

        private var tint: Color { entry.tint }
        private var offBackground: Color { tint.opacity(0.12) }

        init(_ entry: Entry) {
            self.entry = entry
        }

        var body: some View {

            if #available(macOSApplicationExtension 14.0, *) {
                content.containerBackground(for: .widget) {
                    Color.appBackground
                }
            } else {
                ZStack {
                    Color.appBackground
                    content.padding()
                }
            }

        }

        var content: some View {

            let dates = CalendarHelper.makeDates(firstWeekday: entry.firstWeekday, date: date)
            let columns = CalendarHelper.columns
            let spacing = CalendarHelper.spacing(from: dates.count)

            return LazyVGrid(columns: columns, spacing: spacing) {
                Section {
                    ForEach(0..<min(Solar.daysInWeek, dates.count), id: \.self) {
                        weekView(dates[$0].date)
                    }
                    ForEach(dates, id: \.id) { appDate in
                        dayView(appDate: appDate)
                    }
                } header: {
                    header
                }
            }
        }


        @ViewBuilder
        func weekView(_ date: Date) -> some View {
            Text(L10n.widgetShortWeekday(from: date, locale: locale))
                .appForeground(date.inWeekend ? .appSecondary : .appPrimary)
                .sideLength(30)
        }

        @ViewBuilder
        private func dayView(appDate: AppDate) -> some View {

            let showHolidays = !appDate.inNormal && entry.showHolidays,
                showEvents =  appDate.events.isNotEmpty && entry.showEvents,
                showLunar = entry.showLunar,
                defaultColor: Color = appDate.inWeekend ? .appSecondary : .appPrimary,
                inSameMonth = date.inSameMonth(as: appDate.date),
                txColor: Color = appDate.onHoliday ? offBackground : .workBackground

            ZStack {

                if appDate.inToday {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(tint, lineWidth: 1)
                }

                if showHolidays {
                    txColor.clipShape(.rect(cornerRadius: 4))
                    Text(appDate.stateDesc)
                        .font(.system(size: 7, weight: .bold, design: .monospaced))
                        .offset(x: -14, y: -14)
                        .appForeground(appDate.onHoliday ? tint: .appSecondary)
                }

                if showEvents {
                    Circle()
                        .size(width: 5, height: 5)
                        .appForeground(tint)
                        .offset(x: 32, y: 3)
                }

                VStack {
                    Text(appDate.title)
                        .font(.title3.monospacedDigit())
                        .appForeground(showHolidays ? appDate.onHoliday ? tint: defaultColor : defaultColor)
                    if showLunar {
                        Text(appDate.subtitle)
                            .font(.caption2.weight(.regular))
                            .appForeground(showHolidays ? appDate.onHoliday ? tint: .appSecondary : .appSecondary)
                    }
                }

            }
            .opacity(inSameMonth ? 1:0.3)
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
                        Text(L10n.widgetMonthSymbol(from: date.month, locale: locale))
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
                .foregroundStyle(tint)
            } else {
                HStack {
                    Text(L10n.widgetMonthSymbol(from: date.month, locale: locale))
                    Text(date.year.description)
                }
                .font(.title2)
                .appForeground(tint)
            }


        }
    }

}



