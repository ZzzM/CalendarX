//
//  RootView.swift
//  CalendarX
//
//  Created by zm on 2022/1/26.
//

import SwiftUI

struct RootView: View {

    @StateObject
    private var router = Router.shared
    
    @StateObject
    private var alert = AlertAction.shared
    
    @StateObject
    private var mainVM = MainViewModel()
    
    @StateObject
    private var settingsVM = SettingsViewModel()
    
    var body: some View {

        ZStack {
            Color.background.padding(.top, -15)
            content.padding()
            AlertView(alert: alert).zIndex(1)
        }
        .foregroundColor(.primary)
        .environment(\.locale, settingsVM.locale)
        .envTint(settingsVM.color)
        .envColorScheme(settingsVM.colorScheme)
        .onChange(of: settingsVM.locale, notification: NSLocale.currentLocaleDidChangeNotification)
        
        
    }

    @ViewBuilder
    private var content: some View {
        switch router.path {
        case .main: MainView(viewModel: mainVM)
        case .settings: SettingsView(viewModel: settingsVM)
        case .date(let day): DateView(day: day).fullScreenCover()
        case .recommendations: RecommendationsView().fullScreenCover()
        case .menubarSettings: MenubarSettingsView().fullScreenCover()
        case .appearanceSettings: AppearanceSettingsView(viewModel: settingsVM).fullScreenCover()
        case .calendarSettings: CalendarSettingsView().fullScreenCover()
        case .about: AboutView().fullScreenCover()
        }
    }

 
}


