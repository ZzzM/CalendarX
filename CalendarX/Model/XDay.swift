//
//  XDay.swift
//  CalendarX
//
//  Created by zm on 2022/2/15.
//

import SwiftUI

extension XEvent {
    var color: Color { Color(calendar.cgColor) }
}

extension XWeekday: CaseIterable, CustomStringConvertible {
    public static var allCases: [Self]  {
        [.sunday, .monday, .tuesday, wednesday, thursday, friday, saturday]
    }
    public var description: String {
        L10n.weekdaySymbol(from: self)
    }
}

enum XDayState: Int, Decodable, CustomStringConvertible {
    //    0,1,2
    case none, inWorking, onHoliday

    var description: String {
        switch self {
        case .inWorking: return "班"
        case .onHoliday: return "休"
        default: return ""
        }
    }

}

struct XDay: Identifiable {
    
    let id = UUID()
    let date: Date
    let title, subtitle, stateDesc: String
    let solarTerm, lunarFestival: String?
    let inToday, inWeekend, inWorking, onHoliday: Bool

    let events: [XEvent]

    init(_ date: Date, events: [XEvent]) {

        let day = date.day.description
        let year = date.year.description

        let _lunarMonth = Lunar.months[date.lunarMonth - 1]
        let lunarMonth = date.isLeapMonth ? "润" + _lunarMonth : _lunarMonth
        let _lunarDay = Lunar.days[date.lunarDay - 1]
        let lunarDay =  date.lunarDay == 1 ? lunarMonth : _lunarDay

        let state = TiaoXiu[year, date.key]
        let solarFestival = Festival.solar(key: date.key, weekKey: date.weekKey)

        solarTerm = SolarTerm[year, date.key]
        lunarFestival = Festival.lunar(year: year, key: date.key, lunarKey: date.lunarKey)

        title = day
        subtitle = lunarFestival ?? solarTerm ?? solarFestival  ?? lunarDay
        inToday = date.inToday
        inWeekend = date.inWeekend
        inWorking = state == .inWorking
        onHoliday = state == .onHoliday
        stateDesc = state.description
        self.date = date
        self.events = events
    }
}

extension XDay {

    var festivals: [String] {
        var res: [String] = []
        if let festival = lunarFestival { res.append(festival) }
        if let festival = solarTerm { res.append(festival) }
        return res + Festival[date]
    }

    var lunarDate: String {
        let lunarYear = date.lunarYear, zodiacs = Lunar.zodiacs,
            heavenlyStems = Lunar.heavenlyStems, earthlyBranches = Lunar.earthlyBranches
        let i = (lunarYear - 1) % zodiacs.count, zodiac = zodiacs[i]
        let j = (lunarYear - 1) % heavenlyStems.count, heavenlyStem = heavenlyStems[j]
        let k = (lunarYear - 1) % earthlyBranches.count, earthlyBranche = earthlyBranches[k]

        let lunarMonth = Lunar.months[date.lunarMonth - 1], lunarDay = Lunar.days[date.lunarDay - 1]

        let dateString = heavenlyStem
        + earthlyBranche
        + zodiac + "年 "
        + (date.isLeapMonth ? "[润]" + lunarMonth : lunarMonth)
        + lunarDay

        return dateString
    }

}

struct Festival {

    static subscript(date: Date) -> [String] {
        let key = date.key, weekKey = date.weekKey
        var all: [String]  = []
        if let festivals = Solar.allWeekFestivals[weekKey] {
            all += festivals
        }
        if let festival = weekSpecial(date.isInvalidNextWeekday, weekKey: weekKey) {
            all.append(festival)
        }
        if let festivals = Solar.allFestivals[key] {
            all += festivals
        }
        return all
    }

    static func lunar(year: String, key: String, lunarKey: String) -> String? {
        guard Lunar.chuxi[year] != key else { return Lunar.festivals["0100"] }
        return Lunar.festivals[lunarKey]
    }

    static func solar(key: String, weekKey: String) -> String? {
        Solar.weekFestivals[weekKey] ?? Solar.festivals[key]
    }

    static func weekSpecial(_ isInvalidNextWeekday: Bool, weekKey: String) -> String? {
        guard let festival = Solar.weekSpecialFestivals[weekKey] else {
            return .none
        }
        return isInvalidNextWeekday ? festival:.none
    }

}


class SolarTerm {
    private static let shared = SolarTerm()
    private var year: String?
    private var cache: [String: String] = [:]
    private subscript(year: String, key: String) -> String? {
        get {
            guard self.year != year else {
                return cache[key]
            }
            guard let _terms = Solar.terms[year] else {
                return .none
            }
            self.year = year
            cache =  .init(uniqueKeysWithValues: zip(_terms, Solar.termNames))
            return cache[key]
        }
    }
    class subscript(year: String, key: String) -> String? {
        get { shared[year, key] }
    }
}

class TiaoXiu {
    private static let shared = TiaoXiu()
    private var year: String?
    private var cache: [String: XDayState] = [:]
    private subscript(year: String, key: String) -> XDayState {
        get {
            guard self.year != year else {
                return cache[key] ?? .none
            }
            guard let tiaoxiu = Solar.tiaoxiu[year] else {
                return .none
            }
            self.year = year
            cache = tiaoxiu
            return cache[key] ?? .none
        }
    }
    class subscript(year: String, key: String) -> XDayState {
        get { shared[year, key] }
    }
}


