//
//  AppInfo.swift
//  CalendarX
//
//  Created by zm on 2023/12/8.
//

import Foundation

public struct AppInfo: Decodable, Identifiable {
    public var id: String { name }
    public let name: String, about: String, link: String
}
