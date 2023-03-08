//
//  Constant.swift
//  CalendarX
//
//  Created by zm on 2020/6/22.
//  Copyright © 2020 zzzm. All rights reserved.
//
import AppKit
import SwiftUI


typealias VoidClosure = () -> Void
typealias FailureClosure = (Error) -> Void

extension CGFloat {
    static let mainHeight: CGFloat = 300
    static let mainWidth: CGFloat = 320
    static let popoverWidth: CGFloat = 35
    static let popoverHeight: CGFloat = 150
    static let popoverRowHeight: CGFloat = 20
    static let buttonWidth: CGFloat = 35
}

extension UserDefaults {
    static let group = UserDefaults(suiteName: "group.\(AppInfo.identifier)")
}


enum AppStorageKey {
    static let theme = generate("theme")
    static let tint = generate("tint")
    static let language = generate("language")
    private static func generate(_ key: String) -> String { "\(AppInfo.name).app.\(key)" }
}

enum MenubarStorageKey {
    static let style = generate("style")
    static let text = generate("text")
    static let use24h = generate("use24h")
    static let showSeconds = generate("showSeconds")
    static let shownTypes = generate("shownTypes")
    static let hiddenTypes = generate("hiddenTypes")
    private static func generate(_ key: String) -> String { "\(AppInfo.name).menubar.\(key)" }
}

enum CalendarStorageKey {
    static let weekday = generate("weekday")
    static let showEvents = generate("showEvents")
    static let showLunar = generate("showLunar")
    static let showHolidays = generate("showHolidays")
    private static func generate(_ key: String) -> String { "\(AppInfo.name).calendar.\(key)" }
}

extension NSFont {
    static let statusItem = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .regular)
    static let statusIcon = NSFont.monospacedDigitSystemFont(ofSize: 8.5, weight: .regular)
}
extension Image {

    static let power = Image(systemName: "power")
    static let settings = Image(systemName: "gearshape.fill")
    static let warning = Image(systemName: "exclamationmark.circle.fill")
    static let failure = Image(systemName: "xmark.circle.fill")
    static let success = Image(systemName: "checkmark.circle.fill")
    static let close = Image(systemName: "xmark")
    static let clock = Image(systemName: "clock.fill")
    static let leftArrow = Image(systemName: "chevron.left")
    static let rightArrow = Image(systemName: "chevron.right")
    static let circle = Image(systemName: "circle")
    static let recommend = Image(systemName: "hand.thumbsup.fill")
    static let gitHub = Image("GitHub").renderingMode(.template).resizable()
    static let calendar = Image("Calendar").renderingMode(.template).resizable()
}

extension NSImage {
    static let calendar = NSImage(named: "Calendar")!
}

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
    static let chinese = Calendar(identifier: .chinese)
}

extension Locale {
    static let en = Locale(identifier: "en_US")
    static let zh = Locale(identifier: "zh_CN")
    static let posix = Locale(identifier: "en_US_POSIX")
}



extension Color {
    
    static let background = Color(light: "FEF9EF", dark: "323232")
    static let card = Color(light: "F6F6EE", dark: "393939")
    static let primary = Color(light: "555555", dark: "EEEEEE")
    static let secondary = Color(light: "8f8f8f", dark: "777777")
    
    static let workdayBackground = Color.secondary.opacity(0.16)
    static let tagBackground = Color.accentColor.opacity(0.12)
    static let disable = Color.secondary.opacity(0.6)

}

extension NSNotification.Name {
    static let  titleStyleDidChanged = NSNotification.Name("titleStyleDidChanged")
}


struct CalLink {
    static let gitHub = "https://github.com/ZzzM/CalendarX"
}

struct Privacy {
    static let calendars = "com.apple.preference.security?Privacy_Calendars"
    static let notifications = "com.apple.preference.notifications"
}

struct Appearance {
    
    static let tint = palettes[0][0]
    
    static let palettes = [
        ["C72C41", "E97777", "EE4540"], ["4C3575", "5B4B8A", "7858A6"], ["205295", "42C2FF", "2C74B3"],
        ["A1B57D", "519872", "A4B494"], ["AA2B1D", "CC561E", "F07B3F"], ["876445", "CA965C", "847545"],
        ["F1CA89", "A1CAE2", "B25068"], ["704F4F", "AD8B73", "A77979"], ["00A8CC", "1F8A70", "A61F69"],
        ["03C988", "007880", "E0C341"], ["4A89DC", "D770AD", "1363DF"], ["CD4DCC", "59CE8F", "6D67E4"]
    ]
}

struct Lunar {

    //zi     子     rat
    //chou     丑     ox
    //yin     寅     tiger
    //mao     卯     rabbit
    //chen     辰     dragon
    //si     巳     snake
    //wu     午     horse
    //wei     未     goat
    //shen     申     monkey
    //you     酉     rooster
    //xu     戌     dog
    //hai     亥     pig

    //Jia
    //Yi
    //Bing
    //Ding
    //Wu
    //Ji
    //Geng
    //Xin
    //Ren
    //Gui

    static let heavenlyStems = [
        "甲", "乙", "丙", "丁", "戊",
        "己", "庚", "辛", "壬", "癸"
    ]

    static let earthlyBranches = [
        "子", "丑", "寅", "卯",
        "辰", "巳", "午", "未",
        "申", "酉", "戌", "亥"
    ]

    static let zodiacs = [
        "鼠", "牛", "虎", "兔",
        "龙", "蛇", "马", "羊",
        "猴", "鸡", "狗", "猪"
    ]

    static let months = [
        "正月", "二月", "三月", "四月",
        "五月", "六月", "七月", "八月",
        "九月", "十月", "冬月", "腊月"
    ]

    static let days = [
        "初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
        "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
        "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"
    ]

}

struct Solar {

    static let daysInWeek =  7
    static let minYear =  1900, maxYear = 2100
    static let minMonth = 1, maxMonth = 12
    static let minDates = 35, maxDates = 42

}

