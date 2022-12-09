//
//  RootView.swift
//  CalendarX
//
//  Created by zm on 2022/1/26.
//

import SwiftUI

struct RootView: View {
    
    @StateObject
    private var pref = Preference.shared

    @StateObject
    private var router = Router.shared
    
    @State
    private var date = Date()
    
    var body: some View {

        ZStack {
            Color.background.padding(.top, -15)
            content.padding()
        }
        .xTint(pref.color)
        .xColorScheme(pref.colorScheme)
        .environment(\.locale, pref.locale)
        .environmentObject(pref)

    }

    @ViewBuilder
    private var content: some View {
        switch router.path {
        case .main: MainView(date: $date)
        case .settings: SettingsView()
        case .date(let day): DateView(day: day).fullScreenCover()
        case .recommendations: RecommendationsView().fullScreenCover()
        case .menuBarSettings: MenuBarSettingsView().fullScreenCover()
        }
    }

}


