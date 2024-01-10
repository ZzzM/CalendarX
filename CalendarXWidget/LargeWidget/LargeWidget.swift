//
//  LargeWidget.swift
//  CalendarXWidget
//
//  Created by zm on 2024/1/7.
//

import WidgetKit
import SwiftUI
import CalendarXShared

struct LargeWidget: Widget {

    private let kind = "CalendarX.LargeWidget"
    private let intent = Intent.self
    private let provider = Provider()
    private let displayName = L10n.LargeWidget.displayName
    private let description = L10n.LargeWidget.description

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: intent, provider: provider) { entry in
            EntryView(entry)
                .envColorScheme(entry.colorScheme)
        }
        .configurationDisplayName(displayName)
        .description(description)
        .supportedFamilies([.systemLarge])
    }
}
