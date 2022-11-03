//
//  DateView.swift
//  CalendarX
//
//  Created by zm on 2022/1/27.
//

import SwiftUI
import WrappingHStack

struct DateView: View {
    
    @Binding
    var isShown: Bool
    
    let day: XDay
    
    var body: some View {
        VStack(spacing: 10) {
            titleView()
            FestivalsView(festivals: day.festivals)
            SchedulesView(events: day.events)
        }
    }
    
    @ViewBuilder
    func titleView() -> some View {
        HStack {
            ScacleImageButton(image: .close, action: {}).hidden()
            Spacer()
            Text(day.date, style: .date).font(.title2)
            Spacer()
            ScacleImageButton(image: .close) {
                withAnimation { isShown.toggle() }
            }
        }
        
        Text(day.lunarDate).font(.footnote).foregroundColor(.secondary)
    }
    
    
}

struct FestivalsView: View {
    
    let festivals: [String]
    
    @State
    private var isExpanded = true
    
    var body: some View {
        
        Section(content: {
            if isExpanded, festivals.isNotEmpty {
                WrappingHStack(festivals,spacing: .constant(8), lineSpacing: 8) {  festival in
                    ScacleTagButton(title: festival.l10nKey) {
                        NSWorkspace.searching(festival)
                    }
                }.transition(.opacity)
            } else if festivals.isEmpty {
                GroupEmptyRow(title: L10n.Date.noFestivals)
            }

        }, header: header)
    }
    
    func header() -> some View {
        GroupHeader(title: L10n.Date.festivals) {
            if festivals.isNotEmpty {
                ScacleButton {
                    withAnimation {
                        isExpanded.toggle()
                    }
                } label: {
                    RotationArrow(isPresented: $isExpanded)
                }
            }
        }
    }
}


struct SchedulesView: View {
    
    let events: [XEvent]

    var body: some View {

        let hideSchedule = !Preference.shared.showSchedule

        Section {
            ScrollView {
                LazyVStack {
                    if events.isEmpty || hideSchedule  {
                        GroupEmptyRow(title: L10n.Date.noSchedules)
                    } else {
                        ForEach(events, id: \.eventIdentifier) { eventView($0) }
                    }
                }
            }
        } header: {
            GroupHeader(title: L10n.Date.schedules, label: {})
        }

    }

    @ViewBuilder
    func eventView(_ event: XEvent) -> some View {

        HStack {
            event.color.width(5)

            VStack(alignment: .leading) {

                Text(event.title)

                Divider()

                Text(L10n.timeline(from: event.startDate) +
                     " - " +
                     L10n.timeline(from: event.endDate))
                .font(.footnote)

            }
            .padding(5)
            Spacer()
        }
        .background(event.color.opacity(0.1))
        .cornerRadius(4)
    }

}

struct GroupEmptyRow: View {
    let title: LocalizedStringKey
    var body: some View {
        HStack {
            Text(title)
            Spacer()
        }
        .foregroundColor(.secondary)
    }
}

struct GroupHeader<Label: View>: View {
    
    let title: LocalizedStringKey
    
    @ViewBuilder
    let label: () -> Label
    
    var body: some View {
        HStack() {
            Text(title).font(.title3)
            Spacer()
            label()
        }
    }
}
