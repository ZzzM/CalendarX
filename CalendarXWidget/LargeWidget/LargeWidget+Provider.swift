import CalendarXLib
import WidgetKit

extension LargeWidget {
    typealias Intent = WidgetConfigurationIntent

    @MainActor
    struct Provider: @preconcurrency IntentTimelineProvider {
        func placeholder(in context: Context) -> Entry {
            .init()
        }

        func getSnapshot(for configuration: Intent, in context: Context, completion: @escaping (Entry) -> Void) {
            completion(.init(configuration: configuration))
        }

        func getTimeline(for configuration: Intent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
            let date = Date()

            if #available(macOSApplicationExtension 14.0, *), date.canUpdateDate {
                Storage.today()
            }

            let entry =
                if #available(macOSApplicationExtension 14.0, *) {
                    Entry(date: Storage.date, configuration: configuration)
                } else {
                    Entry(date: date, configuration: configuration)
                }
            let timeline = Timeline(entries: [entry], policy: .after(date.startOfTomorrow))
            completion(timeline)
        }
    }
}

extension Date {
    var canUpdateDate: Bool {
        let calendar = Calendar.gregorian
        let start = calendar.startOfDay(for: self)
        let diff = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: start,
            to: self
        )

        guard let year = diff.year, year == 0,
            let month = diff.month, month == 0,
            let day = diff.day, day == 0,
            let hour = diff.hour, hour == 0,
            let minute = diff.minute
        else {
            return false
        }

        return minute <= 1
    }
}
