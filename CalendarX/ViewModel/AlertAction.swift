//
//  AlertAction.swift
//  CalendarX
//
//  Created by zm on 2023/3/5.
//
import SwiftUI
import Combine
import CalendarXShared

class AlertAction: ObservableObject {

    static let shared = AlertAction()
    
    @Published
    var isPresented = false
    
    var title: LocalizedStringKey = "",
        message: LocalizedStringKey = "",
        image: Image = .info,
        no: LocalizedStringKey = L10n.Alert.no,
        yes: LocalizedStringKey = L10n.Alert.yes,
        action: VoidClosure = {}
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        NotificationCenter.default
            .publisher(for: NSPopover.didCloseNotification)
            .sink{  [weak self] _ in
                guard let self else { return }
                dismiss()
            }
            .store(in: &cancellables)
    }
    
    static func exit() {
        shared.image = .info
        shared.message = L10n.Alert.exitMessage
        shared.yes = L10n.Alert.yes
        shared.action = { NSApp.terminate(.none) }
        shared.show()
    }
    
    static func enableNotifications() {
        shared.image = .privacy
        shared.message = L10n.Alert.notificationsMessage
        shared.yes = L10n.Alert.ok
        shared.action = { NSWorkspace.openPreference(Privacy.notifications); shared.dismiss() }
        shared.show()
        
    }
    
    static func enableCalendars() {
        shared.image = .privacy
        shared.message = L10n.Alert.calendarsMessage
        shared.yes = L10n.Alert.ok
        shared.action = { NSWorkspace.openPreference(Privacy.calendars); shared.dismiss() }
        shared.show()
    }
    
    func dismiss() {
        Task { @MainActor in
            withAnimation {
                isPresented = false
            }
        }
    }
    
    private func show() {
        Task { @MainActor in
            withAnimation {
                isPresented = true
            }
        }
    }
    
}
