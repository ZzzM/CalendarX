import Foundation
import SwiftUI

public struct CalendarHelper {

    public static let columns = Array(repeating: GridItem(), count: Solar.daysInWeek)

    public static func makeDates(firstWeekday: AppWeekday, date: Date) -> [AppDate]  {
        var calendar = Calendar.gregorian
        calendar.firstWeekday = firstWeekday.rawValue
        let dates = calendar.generateDates(for: date)

        if EventHelper.isAuthorized {
            let events =  EventHelper.fetchEvents(with: dates.first!, end: dates.last!)
            return dates.map { date in
                AppDate(date, events: events.filter{ $0.startDate.isSameDay(as: date) } )
            }
        } else {
            return dates.map { AppDate($0) }
        }
    }


    public static func spacing(from count: Int) -> CGFloat? {
        count > Solar.minDates ? 1.7: nil
    }

}
