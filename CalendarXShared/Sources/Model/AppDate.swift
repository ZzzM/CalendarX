import SwiftUI
import EventKit

public typealias AppEvent = EKEvent
public typealias AppWeekday = EKWeekday

public extension AppEvent {
    var color: Color { .init(cg: calendar.cgColor) }
}

extension AppWeekday: CaseIterable, CustomStringConvertible {

    public static var allCases: [Self]  {
        [.sunday, .monday, .tuesday, wednesday, thursday, friday, saturday]
    }
    public var description: String {
        L10n.weekdaySymbol(from: self)
    }
}

enum AppDateState: Int, Decodable, CustomStringConvertible {

    static let tiaoxiu = Bundle.tiaoxiu
    //    0,1,2
    case inNormal, inWorking, onHoliday

    var description: String {
        switch self {
        case .inWorking: return "班"
        case .onHoliday: return "休"
        default: return ""
        }
    }

    static subscript(year: String, key: String) -> Self {
        tiaoxiu[year]?[key] ?? .inNormal
    }

}

public struct AppDate: Identifiable {

    public let id = UUID()
    public let date: Date
    public let title, subtitle, stateDesc: String
    public let solarTerm, lunarFestival: String?
    public let inToday, inWeekend, inNormal, onHoliday: Bool

    public let events: [AppEvent]

    private let sKey, lKey, wKey: String
    private let isInvalid: Bool

    public init(_ date: Date, events: [AppEvent] = []) {

        let day = date.day.description,
            year = date.year.description,
            lunarMonth = (date.isLeapMonth ? "润": "") + date.lunarMonthString,
            lunarDay =  date.lunarDay == 1 ? lunarMonth : date.lunarDayString

        sKey = String(format: "%02d%02d", date.month, date.day)
        lKey = String(format: "%02d%02d", date.lunarMonth, date.lunarDay)
        wKey = String(format: "%02d%d%d", date.month, date.weekdayOrdinal, date.weekday)
        isInvalid = date.isInvalidNextWeekday

        solarTerm = SolarTerm[year, sKey]
        lunarFestival = LunarFestival[year, sKey, lKey]

        let state = AppDateState[year, sKey], solarFestival = SolarFestival[wKey, sKey]

        title = day
        subtitle = lunarFestival ?? solarTerm ?? solarFestival  ?? lunarDay
        inToday = date.inToday
        inWeekend = date.inWeekend
        inNormal = state == .inNormal
        onHoliday = state == .onHoliday
        stateDesc = state.description
        self.date = date
        self.events = events

    }

}


public extension AppDate {

    var festivals: [String] {
        [lunarFestival, solarTerm].compactMap{$0} + Festival[wKey, sKey, isInvalid]
    }

    var lunarDate: String {

        let lunarYear = date.lunarYear,
            zodiacs = Lunar.zodiacs,
            heavenlyStems = Lunar.heavenlyStems,
            earthlyBranches = Lunar.earthlyBranches

        let zIndex = (lunarYear - 1) % zodiacs.count,
            hIndex = (lunarYear - 1) % heavenlyStems.count,
            eIndex = (lunarYear - 1) % earthlyBranches.count

        return heavenlyStems[hIndex] +
        earthlyBranches[eIndex] +
        zodiacs[zIndex] + "年 " +
        (date.isLeapMonth ? "[润]":"") +
        date.lunarMonthString +
        date.lunarDayString
    }

}

struct Festival {

    private static let solarAF = Bundle.solarAF// Contains solarPF

    private static let weekAF = Bundle.weekAF

    private static let weekSF = Bundle.weekSF

    static subscript(wKey: String, sKey: String, isInvalid: Bool) -> [String] {

        let wFestivals = weekAF[wKey] ?? [],
            oFestival = isInvalid ? weekSF[wKey] : .none,
            oFestivals = solarAF[sKey] ?? []

        return wFestivals + [oFestival].compactMap{$0} + oFestivals

    }
}


struct SolarFestival {

    private static let solarPF = Bundle.solarPF
    private static let weekPF = Bundle.weekPF

    static subscript(wKey: String, sKey: String) -> String? {
        weekPF[wKey] ?? solarPF[sKey]
    }

}

struct LunarFestival {

    private static let lunarPF = Bundle.lunarPF
    private static let chuxi = Bundle.chuxi

    static subscript(year: String, sKey: String, lKey: String) -> String? {
        chuxi[year] != sKey ? lunarPF[lKey]: lunarPF["0100"]
    }

}


struct SolarTerm {
    private static let terms = Bundle.terms
    private static let termNames = [
        "立春", "雨水", "惊蛰", "春分", "清明", "谷雨",
        "立夏", "小满", "芒种", "夏至", "小暑", "大暑",
        "立秋", "处暑", "白露", "秋分", "寒露", "霜降",
        "立冬", "小雪", "大雪", "冬至", "小寒", "大寒"
    ]
    static subscript(year: String, key: String) -> String? {
        guard let index = terms[year]?.firstIndex(of: key) else {
            return .none
        }
        return termNames[index]
    }
}
