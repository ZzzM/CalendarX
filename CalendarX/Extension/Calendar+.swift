//
//  Calendar+.swift
//  CalendarX
//
//  Created by zm on 2022/1/26.
//

import Foundation

extension Calendar {
    
    func generateDates(for date: Date) -> [Date] {
        
        var dates: [Date] = []
        
        guard let range = range(of: .day, in: .month, for: date) else {
            return dates
        }
        // Range(1..<?) to 0..<?
        let startOfMonth = date.startOfMonth
        for value in Array(range).indices {
            let date = self.date(byAdding: .day, value: value, to: startOfMonth) ?? startOfMonth
            dates.append(date)
        }
        
        var weekday = startOfMonth.weekday
        weekday += weekday >= firstWeekday ? 0 : Solar.daysInWeek

        let lastCount = weekday - firstWeekday

        if lastCount > 0 {
            var lastDates: [Date] = []
            for value in (1...lastCount).reversed() {
                let date = self.date(byAdding: .day, value: -value, to: startOfMonth) ?? startOfMonth
                lastDates.append(date)
            }
            dates = lastDates + dates
        }

        let total = dates.count > Solar.minDates ? Solar.maxDates:Solar.minDates
        let nextCount = total - dates.count
        
        if nextCount > 0, let endOfMonth = dates.last {
            var nextDates: [Date] = []
            for value in 1...nextCount {
                let date = self.date(byAdding: .day, value: value, to: endOfMonth) ?? endOfMonth
                nextDates.append(date)
            }
            dates += nextDates
        }
        
        return dates
    }
    
}


