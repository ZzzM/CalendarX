//
//  CalDay.swift
//  CalendarX
//
//  Created by zm on 2022/2/15.
//

import SwiftUI

extension CalEvent {
    var color: Color { Color(calendar.cgColor) }
}

extension CalWeekday: CaseIterable, CustomStringConvertible {
    
    public static var allCases: [Self]  {
        [.sunday, .monday, .tuesday, wednesday, thursday, friday, saturday]
    }
    public var description: String {
        L10n.weekdaySymbol(from: self)
    }
}

enum CalDayState: Int, Decodable, CustomStringConvertible {
    
    static let states: [String: [String: CalDayState]] = Bundle.main.json2KeyValue(from: "tiaoxiu")
    
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
        states[year]?[key] ?? .inNormal
    }
    
}

struct CalDay: Identifiable {
    
    let id = UUID()
    let date: Date
    let title, subtitle, stateDesc: String
    let solarTerm, lunarFestival: String?
    let inToday, inWeekend, inNormal, onHoliday: Bool
    
    let events: [CalEvent]
    
    private let sKey, lKey, wKey: String
    private let isInvalid: Bool
    
    init(_ date: Date, events: [CalEvent]) {
        
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

        let state = CalDayState[year, sKey], solarFestival = SolarFestival[wKey, sKey]
        
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


extension CalDay {
    
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
    
    private static let festivals = Bundle.main.json2AllFestivals(from: "solarAF") // Contains solarPF

    private static let weekFestivals = Bundle.main.json2AllFestivals(from: "weekAF")

    private static let otherFestivals = Bundle.main.json2Festival(from: "weekSF")

    static subscript(wKey: String, sKey: String, isInvalid: Bool) -> [String] {

        let wFestivals = weekFestivals[wKey] ?? [],
            oFestival = isInvalid ? otherFestivals[wKey] : .none,
            oFestivals = festivals[sKey] ?? []
        
        return wFestivals + [oFestival].compactMap{$0} + oFestivals

    }
}


struct SolarFestival {
    
    private static let festivals = Bundle.main.json2Festival(from: "solarPF")

    private static let weekFestivals = Bundle.main.json2Festival(from: "weekPF")

    static subscript(wKey: String, sKey: String) -> String? {
        weekFestivals[wKey] ?? festivals[sKey]
    }

}

struct LunarFestival {
    
    private static let festivals = Bundle.main.json2Festival(from: "lunarPF")

    private static let eves = Bundle.main.json2Festival(from: "chuxi")

    static subscript(year: String, sKey: String, lKey: String) -> String? {
        eves[year] != sKey ? festivals[lKey]: festivals["0100"]
    }

}


struct SolarTerm {
    private static let terms = Bundle.main.json2AllFestivals(from: "terms")
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
