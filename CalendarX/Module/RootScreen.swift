import CalendarXLib
import SwiftUI

struct RootScreen: View {

    @EnvironmentObject
    private var router: Router

    @EnvironmentObject
    private var dialog: Dialog
    
    @EnvironmentObject
    private var appStore: AppStore

    @EnvironmentObject
    private var menubarStore: MenubarStore
    
    private let updater: Updater

    private let mainVM = MainViewModel()
    
    init(updater: Updater) {
        self.updater = updater
    }

    var body: some View {
        ZStack {
            background
            baseScreen
            topScreen
            dialogScreen
        }
        .appForeground(.appPrimary)
        .preferredLocale(appStore.locale)
        .envTint(appStore.accentColor)
        .envColorScheme(appStore.colorScheme)
        .onChange(of: appStore.locale, notification: NSLocale.currentLocaleDidChangeNotification)
    }

}

extension RootScreen {

    @ViewBuilder
    private var background: some View {  appStore.backgroundColor.padding(.top, -15) }

    @ViewBuilder
    private var baseScreen: some View { screen(from: router.root) }

    @ViewBuilder
    private var topScreen: some View { screen(from: router.top).fullScreenCover(appStore.backgroundColor) }

    @ViewBuilder
    private func screen(from path: Router.Screen) -> some View {
        switch path {
        case .calendar: MainScreen(viewModel: mainVM)
        case .settings: SettingsScreen(updater: updater)
        case .date(let appDate, let events, let festivals): DateScreen(appDate: appDate, events: events, festivals: festivals)
        case .recommendations: RecsScreen()
        case .menubarSettings: MenubarScreen(menubarStore: menubarStore)
        case .appearanceSettings: AppearanceScreen()
        case .calendarSettings: CalendarScreen()
        case .about: AboutScreen(updater: updater)
        default: EmptyView()
        }
    }

}

extension RootScreen {
    @ViewBuilder
    private var dialogScreen: some View {

        ZStack(alignment: .bottom) {
            Color.black
                .opacity(dialog.isPresented ? 0.5 : 0)
                .onTapGesture(perform: dialog.dismiss)

            if dialog.isPresented {
                VStack {
                    dialog.image
                        .font(.largeTitle)
                        .appForeground(.accentColor)

                    if let message = dialog.message {
                        Text(message)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 5)
                    }

                    if let yesTitle = dialog.yesTitle {
                        ScacleCapsuleButton(
                            title: yesTitle,
                            foregroundColor: .white,
                            backgroundColor: .accentColor
                        ) {
                            dialog.handler?()
                            dialog.dismiss()
                        }
                    }

                    if let noTitle = dialog.noTitle {
                        ScacleCapsuleButton(
                            title: noTitle,
                            foregroundColor: .white,
                            backgroundColor: .appSecondary,
                            action: dialog.dismiss
                        )
                    }
                }
                .padding()
                .background(Color.card)
                .clipShape(.rect(cornerRadius: 5))
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .padding()
            }
        }
        .zIndex(1)
    }
}
