import Foundation
import SwiftUI

public struct CalendarHelper {

    public static let columns = Array(repeating: GridItem(), count: Solar.daysInWeek)

    public static func makeDates(firstWeekday: AppWeekday, date: Date) -> [AppDate]  {
        var calendar = Calendar.gregorian
        calendar.firstWeekday = firstWeekday.rawValue
        return calendar.generateDates(for: date)
    }

    public static func spacing(from count: Int) -> CGFloat? {
        count > Solar.minDates ? 1.7: nil
    }

}
