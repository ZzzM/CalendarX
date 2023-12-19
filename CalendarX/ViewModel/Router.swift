//
//  Router.swift
//  CalendarX
//
//  Created by zm on 2022/1/27.
//

import SwiftUI
import CalendarXShared

class Router: ObservableObject {

    static let shared = Router()

    enum Path {
        case main, date(AppDate), settings,
             recommendations, menubarSettings, appearanceSettings, calendarSettings, about
    }

    @Published
    var path = Path.main
    

    private static func to(_ path: Path, animated: Bool = true) {
        if animated {
            withAnimation { shared.path = path }
        } else {
            shared.path = path
        }
    }

    static func to(_ isRightClicked: Bool) {
        to(isRightClicked ? .settings : .main, animated: false)
    }
}

extension Router {

    static func backMain() { to(.main) }

    static func toDate(_ appDate: AppDate) { to(.date(appDate)) }
}

extension Router {
    
    static func backSettings() { to(.settings) }
    
    static func toRecommendations() { to(.recommendations) }

    static func toMenubarSettings() { to(.menubarSettings) }
    
    static func toAppearanceSettings() { to(.appearanceSettings) }

    static func toCalendarSettings() { to(.calendarSettings) }
    
    static func toAbout() { to(.about) }
}
