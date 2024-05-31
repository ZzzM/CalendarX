//
//  AlertAction.swift
//  CalendarX
//
//  Created by zm on 2023/3/5.
//
import SwiftUI
import Combine
import CalendarXShared


enum AlertType {
    case exit, colorPicker

//    var image: Image {
//
//    }
}

class AlertViewModel: ObservableObject {

    static let shared = AlertViewModel()

    @Published
    var isPresented = false

    var title: LocalizedStringKey?,
        message: LocalizedStringKey?,
        image: Image = .text,
        yes: LocalizedStringKey?,
        no: LocalizedStringKey?,
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
        show(.text,
            message: L10n.Alert.exitMessage,
             no: L10n.Alert.no) {
            NSApp.terminate(.none)
        }
    }

    static func enableNotifications() {
        show(.privacy,
            message: L10n.Alert.notificationsMessage,
            yes: L10n.Alert.ok,
             no: L10n.Alert.no) {
            NSWorkspace.openPreference(Privacy.notifications); shared.dismiss()
        }
    }

    static func enableCalendars() {
        show(.privacy,
            message: L10n.Alert.calendarsMessage,
            yes: L10n.Alert.ok,
             no: L10n.Alert.no) {
            NSWorkspace.openPreference(Privacy.calendars); shared.dismiss()
        }
    }

    static func keyboardShortcut() {
        show(.info, message: L10n.Alert.keyboardShortcutMessage, yes: L10n.Alert.ok)
    }

    func dismiss() {
        DispatchQueue.main.async {
            withAnimation { [weak self] in
                guard let self else { return }
                isPresented = false
            }
        }
    }

    private static func show(_ image: Image,
                             title: LocalizedStringKey? = .none,
                             message: LocalizedStringKey,
                             yes: LocalizedStringKey? = L10n.Alert.yes,
                             no: LocalizedStringKey? = .none,
                             action: VoidClosure? = .none) {
        shared.image = image
        shared.title = title
        shared.message = message
        shared.yes = yes
        shared.no = no
        shared.action = action ?? shared.dismiss
        show()
    }

    private static func show() {
        withAnimation {
            shared.isPresented = true
        }
    }

}
