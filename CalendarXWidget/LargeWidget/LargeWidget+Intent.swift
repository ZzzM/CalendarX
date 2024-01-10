//
//  LargeWidgetIntent.swift
//  CalendarXWidget
//
//  Created by zm on 2024/1/7.
//

#if canImport(AppIntents)
import AppIntents
import SwiftUI
@available(macOS 14.0, *)
extension LargeWidget {
    
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

    struct NextMonthIntent: AppIntent {
        static var title: LocalizedStringResource = "Next Month"
        func perform() async throws -> some IntentResult {
            Storage.nextMonth()
            return .result()
        }
    }
    struct LastMonthIntent: AppIntent {
        static var title: LocalizedStringResource = "Last Month"
        func perform() async throws -> some IntentResult {
            Storage.lastMonth()
            return .result()
        }
    }
    
    struct TodayIntent: AppIntent {
        static var title: LocalizedStringResource = "Today"
        func perform() async throws -> some IntentResult {
            Storage.today()
            return .result()
        }
    }
    
    
}

#endif

