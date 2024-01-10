import SwiftUI
import CalendarXShared

struct CalendarXView: View {
    
    @StateObject
    private var router = Router.shared
    
    @StateObject
    private var alertVM = AlertViewModel.shared

    @StateObject
    private var settingsVM = SettingsViewModel()

    
    private let mainVM = MainViewModel()
    
    var body: some View {
        
        ZStack {
            Color.appBackground.padding(.top, -15)
            rootView
            detailView
            AlertView(viewModel: alertVM)
        }
        .appForeground(.appPrimary)
        .environment(\.locale, settingsVM.locale)
        .envTint(settingsVM.color)
        .envColorScheme(settingsVM.colorScheme)
        .onChange(of: settingsVM.locale, notification: NSLocale.currentLocaleDidChangeNotification)

    }

    @ViewBuilder
    private var rootView: some View {
        switch router.root {
        case .calendar: MainView(viewModel: mainVM)
        case .settings: SettingsView(viewModel: settingsVM)
        case .unknown: EmptyView()
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

