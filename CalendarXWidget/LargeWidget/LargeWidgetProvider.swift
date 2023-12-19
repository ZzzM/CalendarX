import WidgetKit
import CalendarXShared

struct LargeWidgetProvider: IntentTimelineProvider {

    typealias Entry = LargeWidgetEntry
    typealias Intent = WidgetConfigurationIntent

    func placeholder(in context: Context) -> Entry {
        .init()
    }
    func getSnapshot(for configuration: Intent, in context: Context, completion: @escaping (Entry) -> Void) {
        completion(.init(configuration: configuration))
    }

    func getTimeline(for configuration: Intent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {

        let date = Date(), entry = Entry(date: date, configuration: configuration)
        let policy: TimelineReloadPolicy = .after(date.startOfTomorrow)
        let timeline = Timeline(entries: [entry], policy: policy)
        completion(timeline)

    }

}
