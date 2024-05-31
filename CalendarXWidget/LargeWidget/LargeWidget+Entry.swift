import WidgetKit
import CalendarXShared
import SwiftUI


extension LargeWidget {
    struct Entry: TimelineEntry {
        let date: Date, configuration: Provider.Intent

        init(date: Date = Date(), configuration: Provider.Intent = .init()) {
            self.date = date
            self.configuration = configuration
        }
    }
}

extension LargeWidget.Entry {

    var accentColor: Color { configuration.accentColor }

    var backgroundColor: Color { configuration.backgroundColor }

    var colorScheme: ColorScheme? { configuration.colorScheme }

    var locale: Locale { configuration.locale }

    var firstWeekday: AppWeekday { configuration.firstWeekday }
}

extension LargeWidget.Entry {
    var showLunar: Bool {
        configuration.showLunar?.boolValue ?? true
    }

    var showEvents: Bool {
        configuration.showEvents?.boolValue ?? false
    }

    var showHolidays: Bool {
        configuration.showHolidays?.boolValue ?? true
    }
}
