//
//  RootView.swift
//  CalendarX
//
//  Created by zm on 2022/1/26.
//

import SwiftUI
import CalendarXShared

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
            Color.appBackground.padding(.top, -15)

            Group {
                rootView
                detailView
            }
            .padding()

            AlertView(alert: alert).zIndex(1)
        }
        .appForeground(.appPrimary)
        .environment(\.locale, settingsVM.locale)
        .envTint(settingsVM.color)
        .envColorScheme(settingsVM.colorScheme)
        .onChange(of: settingsVM.locale, notification: NSLocale.currentLocaleDidChangeNotification)

    }

    @ViewBuilder
    private var rootView: some View {
        if router.isCalendar {
            MainView(viewModel: mainVM)
        } else {
            SettingsView(viewModel: settingsVM)
        }
    }


    @ViewBuilder
    private var detailView: some View {
        switch router.path {
        case .date(let appDate): DateView(appDate: appDate).fullScreenCover()
        case .recommendations: RecommendationsView().fullScreenCover()
        case .menubarSettings: MenubarSettingsView().fullScreenCover()
        case .appearanceSettings: AppearanceSettingsView(viewModel: settingsVM).fullScreenCover()
        case .calendarSettings: CalendarSettingsView().fullScreenCover()
        case .about: AboutView().fullScreenCover()
        default: EmptyView()
        }
    }


}

