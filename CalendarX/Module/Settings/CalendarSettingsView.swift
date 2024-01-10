//
//  CalendarSettingsView.swift
//  CalendarX
//
//  Created by zm on 2023/2/26.
//

import SwiftUI
import Combine
import CalendarXShared

struct CalendarSettingsView: View {
    
    @StateObject
    private var viewModel = CalendarViewModel()

    var body: some View {
        VStack(spacing: 20) {


            TitleView {
                Text(L10n.Settings.calendar)
            } leftItems: {
                ScacleImageButton(image: .backward, action: Router.back)
            } rightItems: {
                EmptyView()
            }

            Section {
                weekRow
                eventsRow
                lunarRow
                holidaysRow
                keyboardShortcutRow
            }
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()

    }
}

extension CalendarSettingsView {
    
    private  var weekRow: some View {
        SettingsPickerRow(title: L10n.Calendar.startWeekOn,
                          items: AppWeekday.allCases,
                          selection:  $viewModel.weekday) { Text($0.description) }
    }
    
    @ViewBuilder
    private var eventsRow: some View {
        let isOn = Binding(
            get: viewModel.getEventStatut,
            set: viewModel.setEventStatut
        )
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
    
    private var keyboardShortcutRow: some View {
        Toggle(isOn: $viewModel.keyboardShortcut) {
            HStack {
                Text(L10n.Calendar.keyboardShortcut).font(.title3)
                ScacleImageButton(image: .tips, action:  AlertViewModel.keyboardShortcut)
            }
        }
        .checkboxStyle()
    }
}



