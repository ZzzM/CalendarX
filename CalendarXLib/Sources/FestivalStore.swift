//
//  FestivalStore.swift
//  CalendarXLib
//
//  Created by zm on 2024/12/30.
//

import Foundation

@MainActor
public enum Tiaoxiu: Int, Decodable {

    //    0,1,2
    case ordinary, ban, xiu

    public var isOrdinary: Bool { self == .ordinary }
    public var isXiu: Bool { self == .xiu }

    public var description: String {
        switch self {
        case .ban: "班"
        case .xiu: "休"
        default: ""
        }
    }

}

@MainActor
public struct FestivalStore {

    typealias TypeA = [String: String]
    typealias TypeB = [String: [String]]
    typealias TypeC = [String: [String: Tiaoxiu]]

    @MainActor
    enum Lunar {
        static let titles = [
            "立春", "雨水", "惊蛰", "春分", "清明", "谷雨",
            "立夏", "小满", "芒种", "夏至", "小暑", "大暑",
            "立秋", "处暑", "白露", "秋分", "寒露", "霜降",
            "立冬", "小雪", "大雪", "冬至", "小寒", "大寒",
        ]
        static let primary = Bundle.module.jsonModel(resource: "festival_lunar_primary") ?? TypeA()
        static let jieqi = Bundle.module.jsonModel(resource: "festival_lunar_jieqi") ?? TypeB()
        static let chuxi = Bundle.module.jsonModel(resource: "festival_lunar_chuxi") ?? TypeA()
    }

    @MainActor
    enum Solar {
        static let all = Bundle.module.jsonModel(resource: "festival_solar_all") ?? TypeB()
        static let primary = Bundle.module.jsonModel(resource: "festival_solar_primary") ?? TypeA()
        static let tiaoxiu = Bundle.module.jsonModel(resource: "festival_solar_tiaoxiu") ?? TypeC()
    }

    @MainActor
    enum Week {
        static let all = Bundle.module.jsonModel(resource: "festival_week_all") ?? TypeB()
        static let primary = Bundle.module.jsonModel(resource: "festival_week_primary") ?? TypeA()
        static let speical = Bundle.module.jsonModel(resource: "festival_week_special") ?? TypeA()
    }

    public nonisolated init() {

    }
}

@MainActor
extension FestivalStore {

    public func all(date: AppDate) -> [String] {

        let isInvalid = date.isInvalidNextWeekday
        let speical = isInvalid ? Week.speical[date.sMWKey] : .none

        var all: [String?] = [lunar(date: date), jieqi(date: date)]
        all.append(contentsOf: Week.all[date.sMWKey] ?? [])
        all.append(speical)
        all.append(contentsOf: Solar.all[date.sMDKey] ?? [])

        return all.compactMap(\.self)
    }

    public func display(date: AppDate) -> String {
        lunar(date: date) ?? jieqi(date: date) ?? solar(date: date) ?? date.lunarDayTitle
    }

    public func tiaoxiu(date: AppDate) -> Tiaoxiu { Solar.tiaoxiu[date.sYKey]?[date.sMDKey] ?? .ordinary }

    private func lunar(date: AppDate) -> String? {
        let key = Lunar.chuxi[date.sYKey] != date.sMDKey ? date.lMDKey : "0100"
        return Lunar.primary[key]
    }

    private func jieqi(date: AppDate) -> String? {
        guard let jq = Lunar.jieqi[date.sYKey] else { return .none }
        let jqMap = TypeA(uniqueKeysWithValues: zip(jq, Lunar.titles))
        return jqMap[date.sMDKey] ?? .none
    }

    private func solar(date: AppDate) -> String? { Week.primary[date.sMWKey] ?? Solar.primary[date.sMDKey] }

}
