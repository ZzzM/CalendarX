//
//  MenuBarController.swift
//  CalendarX
//
//  Created by zm on 2022/1/4.
//

import AppKit
import Schedule
import Combine

class MenuBarController {

    private let popover:  MenuBarPopover

    private lazy var task = Plan
        .at(Date().nextMinute)
        .concat(.every(1.minute))
        .do { [weak self] in
            guard let strong = self else { return }
            strong.updateTitle()
        }

    private lazy var menubarButton: NSStatusBarButton? = {
        guard let button = NSStatusItem.system.button else { return .none }
        button.action = #selector(togglePopover)
        button.target = self
        button.sendAction(on: [.leftMouseDown, .rightMouseDown])
        return button
    }()

    private lazy var monitor = GlobalMonitor { [weak self] _ in
        guard let strong = self else { return }
        guard strong.popover.isShown else { return }
        strong.closePopover()
    }

    private var disposables: Set<AnyCancellable> = []

    private var style: MenuBarStyle {
        Preference.shared.menuBarStyle
    }

    private var title: String {
        L10n.statusBarTitle()
    }

    private var icon: NSImage? {
        style.isDefault ? .menubarIcon: .none
    }

    init(_ popover: MenuBarPopover) {
        self.popover = popover
        self.updateTitle()
        self.addObserver()
        if !style.isDefault { _ = task }
    }

    private func updateTitle() {
        menubarButton?.setImage(icon, title: title)
    }

    private func addObserver() {
        NotificationCenter.default
            .publisher(for: .titleStyleDidChanged)
            .sink { [weak self] _ in
                guard let strong = self else { return }
                strong.updateTask()
                strong.updateTitle()
            }
            .store(in: &disposables)

        NotificationCenter.default
            .publisher(for: .NSCalendarDayChanged)
            .sink(receiveValue: { [weak self] _ in
                guard let strong = self else { return }
                if strong.style.isDefault {
                    strong.updateTitle()
                }
            })
            .store(in: &disposables)
    }

    private func updateTask() {
        style.isDefault ? task.suspend() : task.resume()
    }

}

extension MenuBarController {

    @objc private func togglePopover(_ sender: Any?) {
        popover.isShown ? closePopover(): showPopover(sender)
    }

    private func showPopover(_ sender: Any?) {
        if let event = NSApp.currentEvent, event.isRightClicked {
            Router.toSettings()
        } else {
            Router.toMain()
        }
        popover.show(sender)
        monitor.start()
    }

    private func closePopover() {
        popover.close()
        monitor.stop()
    }
}
