//
//  Launcher.swift
//  CalendarX
//
//  Created by zm on 2023/2/22.
//

import ServiceManagement
import SwiftUI

@available(macOS 13.0, *)
@MainActor
enum Launcher {
    static let observable = Observable()
    static var isEnabled: Bool {
        get { SMAppService.mainApp.status == .enabled }
        set {
            observable.objectWillChange.send()

            do {
                if newValue {
                    if SMAppService.mainApp.status == .enabled {
                        try? SMAppService.mainApp.unregister()
                    }

                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                //print("Failed to \(newValue ? "enable" : "disable") launch at login: \(error.localizedDescription)")
            }
        }
    }
}

@available(macOS 13.0, *)

extension Launcher {
    @MainActor
    class Observable: ObservableObject {
        var isEnabled: Bool {
            get { Launcher.isEnabled }
            set {
                Launcher.isEnabled = newValue
            }
        }
    }
}

@available(macOS 13.0, *)
extension Launcher {

    struct Toggle<Label: View>: View {
        @ObservedObject
        private var launchAtLogin = Launcher.observable
        private let label: Label

        init(@ViewBuilder label: () -> Label) {
            self.label = label()
        }

        var body: some View {
            SwiftUI.Toggle(isOn: $launchAtLogin.isEnabled) { label }
        }
    }
}
