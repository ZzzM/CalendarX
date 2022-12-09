//
//  Router.swift
//  CalendarX
//
//  Created by zm on 2022/1/27.
//

import SwiftUI
//
//class Router: ObservableObject {
//
//}



class Router: ObservableObject {

    static let shared = Router()

    enum Path {
        case main, date(XDay), settings, recommendations, menuBarSettings
    }

    @Published
    var path = Path.main
    
    private func to(_ path: Path) {
        self.path = path
    }

}

extension Router {
    
    static func toMain() {
        shared.to(.main)
    }
    
    static func backMain() {
        withAnimation {
            toMain()
        }
    }
    
    static func toDate(_ day: XDay) {
        withAnimation {
            shared.to(.date(day))
        }
    }
}

extension Router {
    static func toSettings() {
        shared.to(.settings)
    }
    
    static func backSettings() {
        withAnimation {
            toSettings()
        }
    }
    
    static func toRecommendations() {
        withAnimation {
            shared.to(.recommendations)
        }
    }
    
    static func toMenuBarSettings() {
        withAnimation {
            shared.to(.menuBarSettings)
        }
    }
}
