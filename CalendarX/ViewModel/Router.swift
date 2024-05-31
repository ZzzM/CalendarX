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

    enum Root {
        case calendar, settings, unknown
    }

    enum Path {
        case date(AppDate, [AppEvent]), recommendations, menubarSettings, appearanceSettings, calendarSettings, about, unknown
    }

    @Published
    var path = Path.unknown

    @Published
    var root = Root.unknown

    private static func to(_ path: Path, animated: Bool = true) {
        if animated {
            withAnimation { shared.path = path }
        } else {
            shared.path = path
        }
    }

    static func set(_ root: Root) {
        to(.unknown, animated: false)
        shared.root = root
    }

    static func back() {
        to(.unknown)
    }
}

extension Router {
    
    static func toDate(_ appDate: AppDate, events: [AppEvent]) { to(.date(appDate, events)) }

    static func toRecommendations() { to(.recommendations) }

    static func toMenubarSettings() { to(.menubarSettings) }
    
    static func toAppearanceSettings() { to(.appearanceSettings) }

    static func toCalendarSettings() { to(.calendarSettings) }
    
    static func toAbout() { to(.about) }
}
