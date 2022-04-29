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


extension NSStatusItem {
    static let system = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
}

enum AppStorageKey {
    static let theme = "\(AppInfo.name).storageKey.theme"
    static let tint = "\(AppInfo.name).storageKey.tint"
    static let language = "\(AppInfo.name).storageKey.language"
    static let weekday = "\(AppInfo.name).storageKey.weekday"
    static let showSchedule = "\(AppInfo.name).storageKey.showSchedule"
    static let menuBarStyle = "\(AppInfo.name).storageKey.menuBarStyle"
}

extension NSImage {

    static let menubarIcon = NSImage(named: "MenubarIcon")

}
extension Image {

    static let globe = Image(systemName: "globe")
    static let palette = Image(systemName: "paintpalette.fill")
    static let settings = Image(systemName: "gearshape.fill")
    static let warning = Image(systemName: "exclamationmark.circle.fill")
    static let failure = Image(systemName: "xmark.circle.fill")
    static let success = Image(systemName: "checkmark.circle.fill")
    static let download = Image(systemName: "arrow.down")
    static let close = Image(systemName: "xmark")
    static let appLogo = Image("AppLogo", bundle: .main)
    static let leftArrow = Image(systemName: "chevron.left")
    static let rightArrow = Image(systemName: "chevron.right")
    static let circle = Image(systemName: "circle")
    static let link = Image(systemName: "link")
}



extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
    static let chinese = Calendar(identifier: .chinese)
}

extension Locale {
    static let en = Locale(identifier: "en")
    static let zh = Locale(identifier: "zh")
}


extension Color {

    static let background = Color(light: "F5F7FA", dark: "323133")
    static let workdayBackground = Color(light: "E6E9ED", dark: "3C3B3D")

    static let primary = Color(light: "323133", dark: "F5F7FA")
    static let secondary = Color(light: "808080", dark: "B3B3B3")

}

extension NSNotification.Name {
    static let  leftClicked = NSNotification.Name("leftClicked")
    static let  rightClicked = NSNotification.Name("rightClicked")
    static let  titleStyleDidChanged = NSNotification.Name("titleStyleDidChanged")
}


struct XLink {
    static let gitHub = "https://github.com/ZzzM/CalendarX"
}

struct Privacy {
    static let calendars = "com.apple.preference.security?Privacy_Calendars"
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

    static let festivals = Bundle.main.json2Festival(from: "lunarPF")

    static let chuxi = Bundle.main.json2Festival(from: "chuxi")

}

struct Solar {
    
    static let tiaoxiu: [String: [String: XDayState]] = Bundle.main.json2KeyValue(from: "tiaoxiu")
    static let terms = Bundle.main.json2AllFestivals(from: "terms")

    static let daysInWeek =  7
    static let minYear =  1900, maxYear = 2100
    static let minMonth = 1, maxMonth = 12
    static let minDates = 35, maxDates = 42
    
    static let termNames = [
        "立春", "雨水", "惊蛰", "春分", "清明", "谷雨",
        "立夏", "小满", "芒种", "夏至", "小暑", "大暑",
        "立秋", "处暑", "白露", "秋分", "寒露", "霜降",
        "立冬", "小雪", "大雪", "冬至", "小寒", "大寒"
    ]

    static let allFestivals = Bundle.main.json2AllFestivals(from: "solarAF")

    static let allWeekFestivals = Bundle.main.json2AllFestivals(from: "weekAF")

    static let festivals = Bundle.main.json2Festival(from: "solarPF")

    static let weekFestivals = Bundle.main.json2Festival(from: "weekPF")

    static let weekSpecialFestivals = Bundle.main.json2Festival(from: "weekSF")

}

