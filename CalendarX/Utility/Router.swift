//
//  Router.swift
//  CalendarX
//
//  Created by zm on 2022/1/27.
//

import CalendarXLib
import Combine
import SwiftUI

@MainActor
class Router: ObservableObject {

    enum Screen {
        case calendar
        case date(AppDate, [AppEvent], [String])
        case settings, recommendations, menubarSettings, appearanceSettings, calendarSettings, update, about
        case empty
    }

    @Published
    private(set) var path: [Screen] = []

    var root: Screen { path.first ?? .empty }

    var top: Screen { path.count > 1 ? path.last! : .empty }

    func set(_ root: Screen) {
        path = [root]
    }

    func push(_ screen: Screen, animated: Bool = true) {
        if animated {
            withAnimation { path.append(screen) }
        } else {
            path.append(screen)
        }
    }

    func pop(_ animated: Bool = true) {

        guard path.count > 1 else { return }

        if animated {
            withAnimation { _ = path.popLast() }
        } else {
            _ = path.popLast()
        }
    }

    func popAndNofiy(_ name: NSNotification.Name, object: Any? = .none) {
        pop()
        NotificationCenter.default.post(name: name, object: object)
    }
    
    func popOrNotify(_ name: NSNotification.Name, object: Any? = .none) {
        path.count > 1 ? pop():NotificationCenter.default.post(name: name, object: object)
    }
   

}

extension Router {

    func exit() {
        NSApp.terminate(.none)
    }

    func preference(_ privacy: String) {
        let urlString = "x-apple.systempreferences:\(privacy)"
        open(urlString)
    }

    func google(_ keyword: String) {
        let urlString = "https://www.google.com/search?q=\(keyword.urlEncoded)"
        open(urlString)
    }

    func open(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        NSWorkspace.shared.open(url)
    }
}
