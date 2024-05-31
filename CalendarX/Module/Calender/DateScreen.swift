//
//  DateScreen.swift
//  CalendarX
//
//  Created by zm on 2022/1/27.
//

import SwiftUI
import WrappingHStack
import CalendarXShared

struct DateScreen: View {
    
    let appDate: AppDate, events: [AppEvent]

    private var showEvents: Bool { CalendarPreference.shared.showEvents }
    
    var body: some View {
        VStack(spacing: 10) {
            TitleView {
                Text(appDate, style: .date)
            } leftItems: {
                ScacleImageButton(image: .backward, action: Router.back)
            } rightItems: {
                EmptyView()
            }

            Text(appDate.lunarDate).font(.footnote).appForeground(.accentColor)
            FestivalsView(festivals: appDate.festivals)
            EventsView(events: events, showEvents: showEvents)
        }
        .padding()
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
                .font(.subheadline)
            }
        }
    }

}


struct EventsView: View {
    
    let events: [AppEvent], showEvents: Bool

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
    func eventView(_ event: AppEvent) -> some View {

        VStack(alignment: .leading, spacing: 5) {
              
            HStack {
                
                Image.clock.appForeground(event.color)

                if event.isAllDay {
                    Text(L10n.Date.allDay)
                } else {
                    Text(L10n.timeline(from: event.startDate))
                    Text("-")
                    Text(L10n.timeline(from: event.endDate))
                }
                
            }
            .font(.caption2)
            .appForeground(.appSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(event.title).appForeground(.appPrimary)

        }
        .padding(5)
        .background(Color.card)
        .clipShape(.rect(cornerRadius: 5))
        .shadow(radius: 1, x: 1, y: 1)
        .padding(.horizontal, 3)
        


    }
    
}

