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
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            item?.image = itemImage
            item?.attributedTitle = itemTitle
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
    
    private var itemImage: NSImage? {
        .icon != style ? .none: pref.iconType.nsImage
    }

    private var itemTitle: NSAttributedString {

        let title = switch style {
        case .icon: pref.iconItemTitle
        case .date: pref.dateItemTitle
        }

        let font = switch style {
        case .icon: NSFont.statusIcon
        case .date: NSFont.statusItem
        }

        return NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: font])
    }

}
