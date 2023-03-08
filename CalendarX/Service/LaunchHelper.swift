//
//  LaunchHelper.swift
//  CalendarX
//
//  Created by zm on 2023/2/22.
//
import LaunchAtLogin

typealias CalToggle = LaunchAtLogin.Toggle

struct LaunchHelper {
    static func migrateIfNeeded() {
        LaunchAtLogin.migrateIfNeeded()
    }
}
