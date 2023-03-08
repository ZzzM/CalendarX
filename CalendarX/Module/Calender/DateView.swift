//
//  DateView.swift
//  CalendarX
//
//  Created by zm on 2022/1/27.
//

import SwiftUI
import WrappingHStack


struct DateView: View {
    
    let day: CalDay
    
    private var showEvents: Bool { CalendarPreference.shared.showEvents }
    
    var body: some View {
        VStack(spacing: 10) {
            TitleView {
                Text(day.date, style: .date)
            } actions: {
                ScacleImageButton(image: .close, action: Router.backMain)
            }
            Text(day.lunarDate).font(.footnote).foregroundColor(.accentColor)
            FestivalsView(festivals: day.festivals)
            EventsView(events: day.events, showEvents: showEvents)
        }
    }
    
    
}

struct FestivalsView: View {
    
    let festivals: [String]
    
    var body: some View {
        if festivals.isNotEmpty {
            WrappingHStack(festivals, spacing: .constant(8), lineSpacing: 8) {  festival in
                ScacleTagButton(title: festival.l10nKey) {
                    NSWorkspace.searching(festival)
                }
            }
        }
    }

}


struct EventsView: View {
    
    let events: [CalEvent], showEvents: Bool
    
    var body: some View {
        
        Section {
            ScrollView {
                LazyVStack {
                    if events.isEmpty || !showEvents  {
                        RowTitleView(title: L10n.Date.noEvents, font: .none)
                    } else {
                        ForEach(events, id: \.eventIdentifier) { eventView($0) }
                    }
                }
            }
        } header: {
            RowTitleView(title: L10n.Date.events, font: .title3)
        }
        
    }
    
    @ViewBuilder
    func eventView(_ event: CalEvent) -> some View {

        VStack(alignment: .leading, spacing: 5) {
              
            HStack {
                
                Image.clock.foregroundColor(event.color)
                
                if event.isAllDay {
                    Text(L10n.Date.allDay)
                } else {
                    Text(L10n.timeline(from: event.startDate))
                    Text("-")
                    Text(L10n.timeline(from: event.endDate))
                }
                
            }
            .font(.caption2)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(event.title).foregroundColor(.primary)

        }
        .padding(5)
        .background(Color.card)
        .cornerRadius(5)
        .shadow(radius: 1, x: 1, y: 1)
        .padding(.horizontal, 3)
        


    }
    
}

