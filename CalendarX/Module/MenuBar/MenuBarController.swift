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

    private let emptyAttributedString = NSAttributedString()

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
        menubarStore.style != .icon
            ? .none
            : menubarStore.iconType.nsImage(locale: appStore.locale)
    }

    private var menubarButtonTitle: NSAttributedString {
        menubarStore.style != .date
            ? emptyAttributedString
            : .init(
                string: menubarStore.dateItemTitle(locale: appStore.locale),
                attributes: [.font: NSFont.statusItem]
            )
    }
}

extension MenubarController {

    private func setupMenubarObservers() {

        NotificationCenter.default
            .publisher(for: .popoverWillCloseManually)
            .sink { [weak self] _ in
                guard let self else { return }
                popover.close()
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: .titleStyleDidChanged)
            .sink { [weak self] _ in
                guard let self else { return }
                schedule.action?()
                schedule.update()
            }
            .store(in: &cancellables)

        if #available(macOS 12.0, *) {
            Task { [weak self] in
                for await _ in NotificationCenter.default
                    .notifications(named: .NSCalendarDayChanged)
                    .compactMap({ _ in })
                {
                    guard let self else { return }
                    schedule.action?()
                }
            }
        } else {
            NotificationCenter.default
                .publisher(for: .NSCalendarDayChanged)
                .sink { [weak self] _ in
                    guard let self else { return }
                    schedule.action?()
                }
                .store(in: &cancellables)
        }

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
