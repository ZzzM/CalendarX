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



