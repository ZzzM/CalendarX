//
//  Constant.swift
//  CalendarX
//
//  Created by zm on 2020/6/22.
//  Copyright © 2020 zzzm. All rights reserved.
//
import AppKit
import SwiftUI

public typealias VoidClosure = () -> Void
public typealias FailureClosure = (Error) -> Void

extension CGFloat {
    public static let mainHeight: CGFloat = 300
    public static let mainWidth: CGFloat = 320
    public static let popoverWidth: CGFloat = 40
    public static let popoverHeight: CGFloat = 210
    public static let popoverRowHeight: CGFloat = 25
    public static let buttonWidth: CGFloat = 35
}

@MainActor
extension Bundle {
    
    public typealias TypeA = [AppInfo]
    public typealias TypeB = [ColorInfo]


    public static let apps = module.jsonModel(resource: "recommendation_app") ?? TypeA()

    public static let defaultLightAccent = lightAccent[4]
    public static let defaultLightBackground = lightBackground[4]

    public static let defaultDarkAccent = darkAccent[4]
    public static let defaultDarkBackground = darkBackground[4]

    public static let lightAccent = module.jsonModel(resource: "color_light_accent") ?? TypeB()
    public static let lightBackground = module.jsonModel(resource: "color_light_background") ?? TypeB()
    public static let darkAccent = module.jsonModel(resource: "color_dark_accent") ?? TypeB()
    public static let darkBackground = module.jsonModel(resource: "color_dark_background") ?? TypeB()

}

@MainActor
extension UserDefaults {
    public static let group = UserDefaults(suiteName: "group.\(Bundle.identifier)")
}

public enum AppStorageKey {
    public static let theme = generate("theme")
    public static let tint = generate("tint")
    public static let appearance = generate("appearance")
    public static let language = generate("language")
    private static func generate(_ key: String) -> String { "\(Bundle.appName).app.\(key)" }
}

public enum MenubarStorageKey {
    public static let style = generate("style")
    public static let iconType = generate("iconType")
    public static let use24h = generate("use24h")
    public static let showSeconds = generate("showSeconds")
    public static let shownTypes = generate("shownTypes")
    public static let hiddenTypes = generate("hiddenTypes")
    private static func generate(_ key: String) -> String { "\(Bundle.appName).menubar.\(key)" }
}

public enum CalendarStorageKey {
    public static let weekday = generate("weekday")
    public static let showEvents = generate("showEvents")
    public static let showLunar = generate("showLunar")
    public static let showHolidays = generate("showHolidays")
    public static let keyboardShortcut = generate("keyboardShortcut")
    private static func generate(_ key: String) -> String { "\(Bundle.appName).calendar.\(key)" }
}

@MainActor
extension NSFont {
    public static let statusItem = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .regular)
    public static let statusIcon = NSFont.monospacedDigitSystemFont(ofSize: 8.5, weight: .regular)
}

extension Image {
    public static let quit = Image(systemName: "escape")
    public static let backward = Image(systemName: "arrow.backward")
    public static let text = Image(systemName: "text.bubble")
    public static let info = Image(systemName: "info.bubble")
    public static let privacy = Image(systemName: "exclamationmark.shield")
    public static let tips = Image(systemName: "info.circle")
    public static let clock = Image(systemName: "clock.fill")
    public static let leftArrow = Image(systemName: "chevron.left")
    public static let rightArrow = Image(systemName: "chevron.right")
    public static let circle = Image(systemName: "circle")
    public static let recommend = Image(systemName: "hand.thumbsup.fill")
    public static let save = Image(systemName: "checkmark")
    public static let pin = Image(systemName: "paintbrush.pointed.fill")
    public static let house = Image(systemName: "house.fill")
    public static let trash = Image(systemName: "trash.fill")
}

extension Calendar {
    public static let gregorian = Calendar(identifier: .gregorian)
    public static let chinese = Calendar(identifier: .chinese)
}

extension Locale {
    public static let en = Locale(identifier: "en_US")
    public static let zh = Locale(identifier: "zh_CN")
    public static let posix = Locale(identifier: "en_US_POSIX")
}

extension Color {
    //    static let appBackground = Color(light: "FEF9EF", dark: "323232")
    public static let appPrimary = Color(light: "555555", dark: "EEEEEE")
    public static let appSecondary = Color(light: "8f8f8f", dark: "777777")

    public static let card = Color(light: "F9F9F9", dark: "393939")

    public static let workBackground = Color.secondary.opacity(0.16)
    public static let offBackground = Color.accentColor.opacity(0.12)

    public static let tagBackground = Color.accentColor
    public static let disable = Color.secondary.opacity(0.6)
}

extension Notification.Name {
    public static let titleStyleDidChanged = Notification.Name("titleStyleDidChanged")
}

public enum AppLink {
    public static let gitHub = "https://github.com/ZzzM/CalendarX"
}

public enum Privacy {
    public static let calendars = "com.apple.preference.security?Privacy_Calendars"
    public static let notifications = "com.apple.preference.notifications"
}

public enum Lunar {
    // zi     子     rat
    // chou     丑     ox
    // yin     寅     tiger
    // mao     卯     rabbit
    // chen     辰     dragon
    // si     巳     snake
    // wu     午     horse
    // wei     未     goat
    // shen     申     monkey
    // you     酉     rooster
    // xu     戌     dog
    // hai     亥     pig

    // Jia
    // Yi
    // Bing
    // Ding
    // Wu
    // Ji
    // Geng
    // Xin
    // Ren
    // Gui

    public static let tiangan = [
        "甲", "乙", "丙", "丁", "戊",
        "己", "庚", "辛", "壬", "癸",
    ]

    public static let dizhi = [
        "子", "丑", "寅", "卯",
        "辰", "巳", "午", "未",
        "申", "酉", "戌", "亥",
    ]

    public static let shengxiao = [
        "鼠", "牛", "虎", "兔",
        "龙", "蛇", "马", "羊",
        "猴", "鸡", "狗", "猪",
    ]

    public static let months = [
        "正月", "二月", "三月", "四月",
        "五月", "六月", "七月", "八月",
        "九月", "十月", "冬月", "腊月",
    ]

    public static let days = [
        "初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
        "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
        "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十",
    ]
}

public enum Solar {
    public static let gridColumns = Array(repeating: GridItem(), count: daysInWeek)
    public static let daysInWeek = 7
    public static let minYear = 1900, maxYear = 2100
    public static let minMonth = 1, maxMonth = 12
    public static let minDates = 35, maxDates = 42
}
