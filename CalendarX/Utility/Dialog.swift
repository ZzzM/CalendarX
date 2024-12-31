//
//  Dialog.swift
//  CalendarX
//
//  Created by zm on 2023/3/5.
//
import CalendarXLib
import Combine
import SwiftUI

@MainActor
class Dialog: ObservableObject {

    private var cancellables: Set<AnyCancellable> = []

    private var action: Action = .exit

    @Published
    var isPresented = false

    enum Action {
        case exit
        case notifications, calendars, shortcut
    }

    var title: LocalizedStringKey? {
        switch action {
        case .exit: .none
        case .notifications: .none
        case .calendars: .none
        case .shortcut: .none
        }
    }

    var message: LocalizedStringKey? {
        switch action {
        case .exit: L10n.Alert.exitMessage
        case .notifications: L10n.Alert.notificationsMessage
        case .calendars: L10n.Alert.calendarsMessage
        case .shortcut: L10n.Alert.keyboardShortcutMessage
        }
    }

    var image: Image? {
        switch action {
        case .exit: .text
        case .notifications: .privacy
        case .calendars: .privacy
        case .shortcut: .info
        }
    }

    var yesTitle: LocalizedStringKey? {
        switch action {
        case .exit: L10n.Alert.yes
        case .notifications: L10n.Alert.ok
        case .calendars: L10n.Alert.ok
        case .shortcut: L10n.Alert.ok
        }
    }

    var noTitle: LocalizedStringKey? {
        switch action {
        case .exit: L10n.Alert.no
        case .notifications: L10n.Alert.no
        case .calendars: L10n.Alert.no
        case .shortcut: L10n.Alert.no
        }
    }

    var handler: VoidClosure?

    init() {

        NotificationCenter.default
            .publisher(for: NSPopover.didCloseNotification)
            .sink { [weak self] _ in
                guard let self else { return }
                dismiss()
            }
            .store(in: &cancellables)
    }

    func dismiss() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            withAnimation { isPresented = false }
        }
    }

    func popup(_ action: Action, handler: VoidClosure? = .none) {

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.action = action
            self.handler = handler
            withAnimation { isPresented = true }
        }
    }

}
