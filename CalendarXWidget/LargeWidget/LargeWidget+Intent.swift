//
//  LargeWidgetIntent.swift
//  CalendarXWidget
//
//  Created by zm on 2024/1/7.
//

#if canImport(AppIntents)
import AppIntents
import CalendarXLib
import SwiftUI

@available(macOS 14.0, *)

extension LargeWidget {

    @MainActor
    struct Storage {

        @AppStorage("LargeWidget.dateKey")
        static var date: Date = .now

        static func lastMonth() {
            date.lastMonth()
        }

        static func nextMonth() {
            date.nextMonth()
        }

        static func today() {
            date = .now
        }
    }

    @MainActor
    struct NextMonthIntent: AppIntent {
        nonisolated(unsafe) static var title: LocalizedStringResource = "Next Month"
        func perform() async throws -> some IntentResult {
            Storage.nextMonth()
            return .result()
        }
    }

    @MainActor
    struct LastMonthIntent: AppIntent {
        nonisolated(unsafe) static var title: LocalizedStringResource = "Last Month"
        func perform() async throws -> some IntentResult {
            Storage.lastMonth()
            return .result()
        }
    }

    @MainActor
    struct TodayIntent: AppIntent {
        nonisolated(unsafe) static var title: LocalizedStringResource = "Today"
        func perform() async throws -> some IntentResult {
            Storage.today()
            return .result()
        }
    }
}

#endif
