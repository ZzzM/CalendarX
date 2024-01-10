//
//  MenubarItemController.swift
//  CalendarX
//
//  Created by zm on 2023/1/19.
//


import Schedule
import SwiftUI
import CalendarXShared

class MenubarItemController {


    typealias Task = SwiftUI.Task

    private let item: NSStatusBarButton?
    
    private let pref = MenubarPreference.shared
    private var style: MenubarStyle { pref.style }
    
    private lazy var calendarIcon: NSImage = {
        let icon = NSImage.calendar
        icon.size = .init(width: 16, height: 16)
        icon.isTemplate = true
        return icon
    }()
    
    private var task: Schedule.Task?
    
    init(_ statusItem: NSStatusItem, target: AnyObject, action: Selector) {
        item = statusItem.button
        item?.imagePosition = .imageOverlaps
        item?.target = target
        item?.action = action
        item?.sendAction(on: [.leftMouseDown, .rightMouseDown])
        updateItem()
        updateTask()

        
    }
    
    func updateItem() {
        Task { @MainActor in
            item?.image = icon
            item?.attributedTitle = title
        }
    }
    
    func updateTask() {
        if isSuspendable {
            suspendTask()
        } else {
            resumeTask()
        }
    }
    
    
    private func suspendTask() {
        guard let task else { return }
        guard task.suspensionCount == 0 else { return }
        task.suspend()
    }
    
    private func resumeTask() {
        task = plan.do { [weak self] in
            guard let self else { return }
            updateItem()
        }
    }
    
}

extension MenubarItemController {
    
    private var plan: Plan  {
        pref.showSeconds ?
            .at(Date().nextSec).concat(.every(1.second)) :
            .at(Date().nextMin).concat(.every(1.minute))
    }
    
    private var isSuspendable: Bool {
        pref.style.isNotDate || !pref.shownTypes.contains(.t)
    }
    
}

extension MenubarItemController {
    private var icon: NSImage? { style == .default ? calendarIcon : .none }
    private var title: NSAttributedString {

        let title = switch style {
        case .default: Date().day.description
        case .text: pref.text
        case .date: pref.dateItemTitle
        }
        
        let attributes: [NSAttributedString.Key : Any] = if style == .default {
            [.font: NSFont.statusIcon, .baselineOffset: -1]
        } else {
            [.font: NSFont.statusItem]
        }
        return NSAttributedString(string:  title, attributes: attributes)
    }
}
