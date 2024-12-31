//
//  LargeWidget.swift
//  CalendarXWidget
//
//  Created by zm on 2024/1/7.
//

import CalendarXLib
import SwiftUI
import WidgetKit

struct LargeWidget: Widget {
    private let kind = "CalendarX.LargeWidget"
    private let intent = Intent.self
    private let provider = Provider()
    private let displayName = L10n.LargeWidget.displayName
    private let description = L10n.LargeWidget.description
    private var calendar: Calendar = .gregorian

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: intent, provider: provider) { entry in
            EntryView(entry: entry, calendar: calendar)
                .envColorScheme(entry.colorScheme)
        }
        .configurationDisplayName(displayName)
        .description(description)
        .supportedFamilies([.systemLarge])
    }
}
