//
//  AppInfo.swift
//  CalendarX
//
//  Created by zm on 2021/12/30.
//

import Foundation


enum AppInfoKey: String {
    case build = "CFBundleVersion",
         version = "CFBundleShortVersionString",
         identifier = "CFBundleIdentifier",
         name = "CFBundleName",
         commitHash = "CommitHash",
         commitDate = "CommitDate"
}

struct AppInfo {

    private static subscript(key: AppInfoKey) -> String {
        Bundle.main.infoDictionary?[key.rawValue] as? String ?? "none"
    }

    static let name = Self[.name]
    static let version = Self[.version]
    static let commitHash = Self[.commitHash]
    static let commitDate = Self[.commitHash]
}
