//
//  CalendarXWidgetBundle.swift
//  CalendarXWidget
//
//  Created by zm on 2023/12/15.
//
import WidgetKit
import SwiftUI
import CalendarXShared

@main
struct CalendarXWidgetBundle: WidgetBundle {

    @WidgetBundleBuilder
    var body: some Widget {
        LargeWidget()
    }
}

struct LargeWidget: Widget {

    private let kind = "CalendarX.LargeWidget"
    private let intent = LargeWidgetProvider.Intent.self
    private let provider = LargeWidgetProvider()
    private let displayName = L10n.LargeWidget.displayName
    private let description = L10n.LargeWidget.description

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: intent, provider: provider) { entry in
            LargeWidgetView(entry)
                .envColorScheme(entry.colorScheme)
        }
        .configurationDisplayName(displayName)
        .description(description)
        .supportedFamilies([.systemLarge])
    }
}

