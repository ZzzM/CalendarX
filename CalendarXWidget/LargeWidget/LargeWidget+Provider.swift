import WidgetKit
import CalendarXShared


extension LargeWidget {

    typealias Intent = WidgetConfigurationIntent

    struct Provider: IntentTimelineProvider {
        
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

            let entry = if #available(macOSApplicationExtension 14.0, *) {
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
        let diff = Calendar.gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                     from: startOfMonth,
                                                     to: self)
        guard let year = diff.year, year == 0,
              let month = diff.month, month == 0,
              let day = diff.day, day == 0,
              let hour = diff.hour, hour == 0,
              let min = diff.minute, min == 0,
              let sec = diff.second, abs(sec) < 3 else {
            return false
        }

        return true
    }
}

