//
//  MenubarController.swift
//  CalendarX
//
//  Created by zm on 2022/1/4.
//

import AppKit
import Combine
import CalendarXShared
import WidgetKit

class MenubarController {
    
    private let popover: MenubarPopover
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    private lazy var itemController = MenubarItemController(statusItem,
                                                            target: self,
                                                            action: #selector(togglePopover))
    
    private lazy var monitor = MonitorHelper { [weak self] _ in
        guard let self else { return }
        guard popover.isShown else { return }
        closePopover()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(_ popover: MenubarPopover) {
        self.popover = popover
        self.addObserver()
        _ = itemController
    }
    
}

extension MenubarController {
    
    private func addObserver() {
        
        NotificationCenter.default
            .publisher(for: .titleStyleDidChanged)
            .sink { [weak self] _ in
                guard let self else { return }
                itemController.updateItem()
                itemController.updateTask()
            }
            .store(in: &cancellables)
    
        NotificationCenter.default
            .publisher(for: .NSCalendarDayChanged)
            .sink{ [weak self] _ in
                guard let self else { return }
                itemController.updateItem()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: NSLocale.currentLocaleDidChangeNotification)
            .sink{ [weak self] _ in
                guard let self else { return }
                itemController.updateItem()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: .NSSystemClockDidChange)
            .sink{ [weak self] _ in
                guard let self else { return }
                itemController.updateItem()
                itemController.updateTask()
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
        popover.isShown ? closePopover(): showPopover(sender)
    }
    
    private func showPopover(_ sender: Any?) {
        guard let event = NSApp.currentEvent else { return }
        Router.set(event.isRightClicked ? .settings: .calendar)
        popover.show(sender)
        monitor.start()
    }
    
    private func closePopover() {
        popover.close()
        monitor.stop()
    }
}

