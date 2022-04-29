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
        case main, settings
    }

    @Published
    var path = Path.main

    private func to(_ path: Path) {
        self.path = path
    }

    static func toSettings() {
        shared.to(.settings)
    }
    static func toMain() {
        shared.to(.main)
    }
}
