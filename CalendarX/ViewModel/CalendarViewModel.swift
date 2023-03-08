//
//  CalendarViewModel.swift
//  CalendarX
//
//  Created by zm on 2023/3/2.
//

import SwiftUI
import Combine

class CalendarViewModel: ObservableObject {
    
    private let pref = CalendarPreference.shared
    
    @Published
    var weekday = CalendarPreference.shared.weekday {
        didSet { pref.weekday = weekday }
    }
    
    @Published
    var showLunar = CalendarPreference.shared.showLunar {
        didSet { pref.showLunar = showLunar }
    }
    
    @Published
    var showHolidays = CalendarPreference.shared.showHolidays {
        didSet { pref.showHolidays = showHolidays }
    }
    
    @Published
    private var showEvents = CalendarPreference.shared.showEvents {
        didSet { pref.showEvents = showEvents }
    }
    
    func getEventStatut() -> Bool { showEvents }

    func setEventStatut(_ value: Bool) {
        if EventHelper.isDenied {
            AlertAction.enableCalendars()
        } else if EventHelper.isNotDetermined {
            Task { @MainActor in
                showEvents = await EventHelper.requestAccess()
            }
        } else {
            showEvents = value
        }
    }
    
}
