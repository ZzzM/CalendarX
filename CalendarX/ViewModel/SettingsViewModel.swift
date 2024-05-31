//
//  SettingsViewModel.swift
//  CalendarX
//
//  Created by zm on 2023/2/17.
//

import SwiftUI
import Combine
import CalendarXShared

class SettingsViewModel: ObservableObject {
    
    private let pref = Preference.shared
    
    private var cancellables: Set<AnyCancellable> = []
    
    // Settings
    @Published
    var automaticallyChecksForUpdates = Updater.automaticallyChecksForUpdates {
        didSet {
            Updater.automaticallyChecksForUpdates =  automaticallyChecksForUpdates
        }
    }
    
    @Published
    var language = Preference.shared.language {
        didSet { pref.language = language }
    }
    
    var locale: Locale { language.locale }

    var menubarStyle: MenubarStyle { MenubarPreference.shared.style }
    
    // Appearance
    @Published
    var appearance = Preference.shared.appearance {
        didSet {
            pref.appearance = appearance
        }
    }

    @Published
    var theme = Preference.shared.theme {
        didSet { pref.theme = theme }
    }

    @Published
    var isSystemTheme = Preference.shared.theme == .system  {
        didSet {
            theme = if isSystemTheme { .system } else { isDarkTheme ? .dark: .light }
        }
    }
    
    private var isDarkTheme: Bool {
        NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .vibrantDark]) == .darkAqua
    }

    var accentColor: Color { pref.accentColor }

    var backgroundColor: Color { pref.backgroundColor }

    var colorScheme: ColorScheme? { pref.colorScheme }
    

    init() {
        
        NotificationCenter.default
            .publisher(for: NSPopover.willShowNotification)
            .sink{  [weak self] _ in
                guard let self else { return }
                if Updater.isAuthorized { return }
                guard automaticallyChecksForUpdates else { return }
                automaticallyChecksForUpdates = false
            }
            .store(in: &cancellables)
     
    }
    
}

extension SettingsViewModel {
    
    func getNotificationStatut() -> Bool { automaticallyChecksForUpdates }

    func setNotificationStatut(_ value: Bool) {
        if Updater.isDenied {
            AlertViewModel.enableNotifications()
        } else if Updater.isNotDetermined {
            Task { @MainActor in
                automaticallyChecksForUpdates = await Updater.requestAuthorization()
            }
        } else {
            automaticallyChecksForUpdates = value
        }
    }
}
