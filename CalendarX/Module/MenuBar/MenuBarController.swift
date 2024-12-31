//
//  MenubarController.swift
//  CalendarX
//
//  Created by zm on 2022/1/4.
//

import AppKit
import CalendarXLib
import Combine
import WidgetKit

@MainActor
class MenubarController {

    private let appStore: AppStore

    private let menubarStore: MenubarStore

    private let popover: MenubarPopover

    private let schedule: MenubarSchedule

    private let menubarItem: NSStatusItem

    private let menubarButton: NSStatusBarButton?

    private var cancellables: Set<AnyCancellable> = []

    init(appStore: AppStore, menubarStore: MenubarStore, popover: MenubarPopover) {
        self.appStore = appStore
        self.menubarStore = menubarStore
        self.popover = popover
        self.schedule = MenubarSchedule(menubarStore: menubarStore)
        self.menubarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.menubarButton = menubarItem.button

        setupMenubarButton()
        setupMenubarSchedule()
        setupMenubarObservers()

    }

}

extension MenubarController {

    private func setupMenubarSchedule() {
        schedule.action = { [weak self] in
            guard let self else { return }
            menubarButton?.image = menubarButtonImage
            menubarButton?.attributedTitle = menubarButtonTitle
        }
        schedule.action?()
        schedule.update()
    }

    private func setupMenubarButton() {
        menubarButton?.imagePosition = .imageOverlaps
        menubarButton?.target = self
        menubarButton?.action = #selector(togglePopover)
        menubarButton?.sendAction(on: [.leftMouseDown, .rightMouseDown])
    }

    private var menubarButtonImage: NSImage? {
        menubarStore.style != .icon ? .none : menubarStore.iconType.nsImage(locale: appStore.locale)
    }

    private var menubarButtonTitle: NSAttributedString {
        let title =
            switch menubarStore.style {
            case .icon: menubarStore.iconType.title
            case .date: menubarStore.dateItemTitle(locale: appStore.locale)
            }

        let font =
            switch menubarStore.style {
            case .icon: NSFont.statusIcon
            case .date: NSFont.statusItem
            }

        return NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: font])
    }
}

extension MenubarController {

    private func setupMenubarObservers() {
        NotificationCenter.default
            .publisher(for: .titleStyleDidChanged)
            .sink { [weak self] _ in
                guard let self else { return }
                schedule.action?()
                schedule.update()
            }
            .store(in: &cancellables)

        NSWorkspace.shared.notificationCenter
            .publisher(for: .NSCalendarDayChanged)
            .sink { [weak self] _ in
                guard let self else { return }
                schedule.action?()
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: NSLocale.currentLocaleDidChangeNotification)
            .sink { [weak self] _ in
                guard let self else { return }
                schedule.action?()
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: .NSSystemClockDidChange)
            .sink { [weak self] _ in
                guard let self else { return }
                schedule.action?()
                schedule.update()
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: .EKEventStoreChanged)
            .sink { _ in
                WidgetCenter.shared.reloadAllTimelines()
            }
            .store(in: &cancellables)
    }
}

extension MenubarController {

    @objc private func togglePopover(_ sender: Any?) {
        popover.isShown ? popover.close() : popover.show(sender)
    }

}
