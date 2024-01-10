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
    var tint = Preference.shared.tint {
        didSet { pref.tint = tint }
    }
    
    @Published
    var isSystem = Preference.shared.theme == .system {
        didSet {
            if isSystem {
                pref.theme = .system
            } else {
                isDark = NSApp.effectiveAppearance.name == .darkAqua
            }
        }
    }
    
    @Published
    var isDark = Preference.shared.theme == .dark  {
        didSet {  pref.theme = isDark ? .dark : .light }
    }
    
    var isShown: Bool { !isSystem }
    
    var color: Color { Color(hex: tint) }
    
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
