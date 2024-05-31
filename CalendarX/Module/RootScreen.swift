import SwiftUI
import CalendarXShared

struct RootScreen: View {
    
    @StateObject
    private var router = Router.shared
    
    @StateObject
    private var alertVM = AlertViewModel.shared

    @StateObject
    private var settingsVM = SettingsViewModel()

    private let mainVM = MainViewModel()
    
    var body: some View {
        
        ZStack {
            settingsVM.backgroundColor.padding(.top, -15)
            containerScreen
            detailScreen.fullScreenCover(settingsVM.backgroundColor)
            AlertScreen(viewModel: alertVM)
        }
        .appForeground(.appPrimary)
        .environment(\.locale, settingsVM.locale)
        .envTint(settingsVM.accentColor)
        .envColorScheme(settingsVM.colorScheme)
        .onChange(of: settingsVM.locale, notification: NSLocale.currentLocaleDidChangeNotification)

    }

    @ViewBuilder
    private var containerScreen: some View {
        switch router.root {
        case .calendar: MainScreen(viewModel: mainVM)
        case .settings: SettingsScreen(viewModel: settingsVM)
        case .unknown: EmptyView()
        }
    }


    @ViewBuilder
    private var detailScreen: some View {
        switch router.path {
        case .date(let appDate, let events): DateScreen(appDate: appDate, events: events)
        case .recommendations: RecommendationsScreen()
        case .menubarSettings: MenubarStyleScreen()
        case .appearanceSettings: AppearanceScreen(viewModel: settingsVM)
        case .calendarSettings: CalendarScreen()
        case .about: AboutScreen()
        default: EmptyView()
        }

    }


}

