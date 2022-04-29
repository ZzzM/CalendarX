//
//  Updater.swift
//  CalendarX
//
//  Created by zm on 2022/1/4.
//  Copyright © 2022 zzzm. All rights reserved.
//

import Sparkle
import AppKit

class Updater: ObservableObject {
    
    private let updaterController: SPUStandardUpdaterController

    private static let shared = Updater()

    @Published
    var findValidUpdate = false

    init() {
        updaterController = SPUStandardUpdaterController(startingUpdater: true,
                                                         updaterDelegate: .none,
                                                         userDriverDelegate: .none)
        //checkForUpdateInformation()
    }


    private func checkForUpdateInformation() {
        updaterController.updater.checkForUpdateInformation()
        NotificationCenter.default
            .publisher(for: .SUUpdaterDidNotFindUpdate)
            .map { _ in false }
            .assign(to: &$findValidUpdate)
        NotificationCenter.default
            .publisher(for: .SUUpdaterDidFindValidUpdate)
            .map { _ in true }
            .assign(to: &$findValidUpdate)
    }


    static func checkForUpdates() {
        shared.updaterController.checkForUpdates(.none)
    }

}

