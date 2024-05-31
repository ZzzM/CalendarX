import SwiftUI
import EventKit

public typealias AppEvent = EKEvent
public typealias AppWeekday = EKWeekday
public typealias AppDate = Date

public extension AppEvent {
    var color: Color { .init(cg: calendar.cgColor) }
    var eventsKey: String { startDate.eventsKey }
}

extension AppWeekday: CaseIterable, CustomStringConvertible {

    public static var allCases: [Self]  {
        [.sunday, .monday, .tuesday, wednesday, thursday, friday, saturday]
    }
    public var description: String {
        L10n.weekdaySymbol(from: self)
    }
}


public extension AppDate {
    
    var title: String { day.description }
    var subtitle: String { lunarFestival ?? jieqi ?? solarFestival  ?? lunarDayTitle }
    private var isInvalid: Bool { isInvalidNextWeekday }

    private var lunarMonthTitle: String { (isLeapMonth ? "润": "") + lunarMonthString }
    private var lunarDayTitle: String { lunarDay == 1 ? lunarMonthTitle : lunarDayString }

    private var yearKey: String { year.description }
    private var sKey: String { .init(format: "%02d%02d", month, day) }
    private var lKey: String { .init(format: "%02d%02d", lunarMonth, lunarDay) }
    private var wKey: String { .init(format: "%02d%d%d", month, weekdayOrdinal, weekday) }

    private var jieqi: String? { Jieqi[yearKey, sKey] }
    private var lunarFestival: String? { LunarFestival[yearKey, sKey, lKey] }
    private var solarFestival: String? { SolarFestival[wKey, sKey] }

    private var tiaoxiu: Tiaoxiu { Tiaoxiu[yearKey, sKey] }
    var isOrdinary: Bool { .ordinary == tiaoxiu }
    var isXiu: Bool { .xiu == tiaoxiu }
    var tiaoxiuTitle: String { tiaoxiu.description }

    var festivals: [String] {
        [lunarFestival, jieqi].compactMap{$0} + Festival[wKey, sKey, isInvalid]
    }

    var lunarDate: String {

        let lunarYear = lunarYear,
            shengxiao = Lunar.shengxiao,
            tiangan = Lunar.tiangan,
            dizhi = Lunar.dizhi

        let sIndex = (lunarYear - 1) % shengxiao.count,
            tIndex = (lunarYear - 1) % tiangan.count,
            dIndex = (lunarYear - 1) % dizhi.count

        return tiangan[tIndex] +
        dizhi[dIndex] +
        shengxiao[sIndex] + "年 " +
        (isLeapMonth ? "[润]":"") +
        lunarMonthString +
        lunarDayString
    }
}

struct Festival {

    private static let solarAll = Bundle.solarAll

    private static let weekAll = Bundle.weekAll

    private static let weekSpeical = Bundle.weekSpeical

    static subscript(wKey: String, sKey: String, isInvalid: Bool) -> [String] {

        let weekAllFestivals = weekAll[wKey] ?? [],
            weekSpeicalFestival = isInvalid ? weekSpeical[wKey] : .none,
            solarAllFestivals = solarAll[sKey] ?? []

        return weekAllFestivals + [weekSpeicalFestival].compactMap{$0} + solarAllFestivals

    }
}


struct SolarFestival {

    private static let solarPrimary = Bundle.solarPrimary
    private static let weekPrimary = Bundle.weekPrimary

    static subscript(wKey: String, sKey: String) -> String? {
        weekPrimary[wKey] ?? solarPrimary[sKey]
    }

}

struct LunarFestival {

    private static let primary = Bundle.lunarPrimary
    private static let chuxi = Bundle.lunarChuxi

    static subscript(year: String, sKey: String, lKey: String) -> String? {
        chuxi[year] != sKey ? primary[lKey]: primary["0100"]
    }

}

enum Tiaoxiu: Int, Decodable, CustomStringConvertible {

    static let tiaoxiu = Bundle.solarTiaoxu
    //    0,1,2
    case ordinary, ban, xiu

    var description: String {
        switch self {
        case .ban: return "班"
        case .xiu: return "休"
        default: return ""
        }
    }

    static subscript(year: String, key: String) -> Self {
        tiaoxiu[year]?[key] ?? .ordinary
    }

}

struct Jieqi {
    private static let jieqi = Bundle.lunarJieqi
    private static let jieqiTitles = [
        "立春", "雨水", "惊蛰", "春分", "清明", "谷雨",
        "立夏", "小满", "芒种", "夏至", "小暑", "大暑",
        "立秋", "处暑", "白露", "秋分", "寒露", "霜降",
        "立冬", "小雪", "大雪", "冬至", "小寒", "大寒"
    ]
    static subscript(year: String, key: String) -> String? {
        guard let index = jieqi[year]?.firstIndex(of: key) else {
            return .none
        }
        return jieqiTitles[index]
    }
}
