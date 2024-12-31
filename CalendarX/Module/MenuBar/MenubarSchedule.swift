//
//  MenubarSchedule.swift
//  CalendarX
//
//  Created by zm on 2024/11/25.
//

import Schedule
import SwiftUI
import CalendarXLib

@MainActor
class MenubarSchedule {

    var action: VoidClosure?
    
    let menubarStore: MenubarStore

    private var task: Schedule.Task?

    init(menubarStore: MenubarStore) {
        self.menubarStore = menubarStore
    }

    func update() {
        if isSuspendable {
            suspend()
        } else {
            resume()
        }
    }

    private func suspend() {
        guard let task else { return }
        guard task.suspensionCount == 0 else { return }
        task.suspend()
    }

    private func resume() {
        task = plan.do { [weak self] in
            guard let self else { return }
            action?()
        }
    }
}

extension MenubarSchedule {
    private var plan: Plan {
        menubarStore.showSeconds ? .at(Date().nextSec).concat(.every(1.second)) : .at(Date().nextMin).concat(.every(1.minute))
    }

    private var isSuspendable: Bool {
        menubarStore.style != .date || !menubarStore.shownTypes.contains(.t)
    }
}
