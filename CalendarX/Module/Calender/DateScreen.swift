//
//  DateScreen.swift
//  CalendarX
//
//  Created by zm on 2022/1/27.
//

import CalendarXLib
import SwiftUI
import WrappingHStack

struct DateScreen: View {

    @EnvironmentObject
    private var calendarStore: CalendarStore

    @EnvironmentObject
    private var router: Router

    let appDate: AppDate
    let events: [AppEvent]
    let festivals: [String]

    var body: some View {
        VStack(spacing: 10) {
            TitleView {
                Text(appDate, style: .date)
            } leftItems: {
                ScacleImageButton(image: .backward) {
                    router.pop()
                }
            } rightItems: {
                EmptyView()
            }

            Text(appDate.lunarDate).font(.footnote)
            FestivalsView(festivals: festivals) { festival in
                router.google(festival)
            }
            EventsView(events: events, showEvents: calendarStore.showEvents)
        }
        .padding()

    }
}

struct FestivalsView: View {

    let festivals: [String], action: (String) -> Void

    var body: some View {
        if festivals.isNotEmpty {
            WrappingHStack(festivals, spacing: .constant(5), lineSpacing: 5) { festival in
                ScacleButton {
                    action(festival)
                } label: {
                    Text(festival)
                        .padding(3)
                        .background(Color.tagBackground)
                        .appForeground(.white)
                        .clipShape(.rect(cornerRadius: 3))
                        .font(.caption2)
                }
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
                    if events.isEmpty || !showEvents {
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
                    Text(event.startDate.eventTimeline)
                    Text("-")
                    Text(event.endDate.eventTimeline)
                }

                //  Remove Event ?
                //                Spacer()
                //
                //                ScacleButton {
                //
                //                } label: {
                //                    Image.trash
                //                }

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
