//
//  CalendarSettingsView.swift
//  CalendarX
//
//  Created by zm on 2023/2/26.
//

import SwiftUI
import Combine

struct CalendarSettingsView: View {
    
    @StateObject
    private var viewModel = CalendarViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            
            TitleView {
                Text(L10n.Settings.calendar)
            } actions: {
                ScacleImageButton(image: .close, action: Router.backSettings)
            }
            
            Section {
                weekRow
                eventsRow
                lunarRow
                holidaysRow
            }
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

extension CalendarSettingsView {
    
    private  var weekRow: some View {
        SettingsPickerRow(title: L10n.Calendar.startWeekOn,
                          items: CalWeekday.allCases,
                          selection:  $viewModel.weekday) { Text($0.description) }
    }
    
    @ViewBuilder
    private var eventsRow: some View {
        let isOn = Binding(get: viewModel.getEventStatut, set: viewModel.setEventStatut)
        Toggle(isOn: isOn) { Text(L10n.Calendar.showEvents).font(.title3) }
            .checkboxStyle()
        
    }
    
    private var lunarRow: some View {
        Toggle(isOn: $viewModel.showLunar) { Text(L10n.Calendar.showLunar).font(.title3) }
            .checkboxStyle()
    }
    
    private var holidaysRow: some View {
        Toggle(isOn: $viewModel.showHolidays) { Text(L10n.Calendar.showHolidays).font(.title3) }
            .checkboxStyle()
    }
    
}


