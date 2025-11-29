//
//  DateScreen.swift
//  CalendarX
//
//  Created by zm on 2022/1/27.
//

import CalendarXLib
import SwiftUI

struct DateScreen: View {

    @EnvironmentObject
    private var appStore: AppStore

    @EnvironmentObject
    private var calendarStore: CalendarStore

    @EnvironmentObject
    private var router: Router

    let appDate: AppDate
    let events: [AppEvent]
    let festivals: [String]
    let calendar: Calendar

    var body: some View {

        VStack(spacing: 10) {
            TitleView {
                VStack {
                    Text(appDate, style: .date)
                    Text(
                        appDate.weekOfYearTitle(
                            calendar: calendar,
                            locale: appStore.locale
                        )
                    )
                    .font(.body)
                }

            } leftItems: {
                ScacleImageButton(image: .backward) {
                    router.pop()
                }
            } rightItems: {
                VStack(alignment: .trailing) {
                    Text(appDate.lunarYearTitle)
                    Text(appDate.lunarDateTitle)
                }
                .font(.footnote)
            }

            FestivalsView(festivals: festivals) { festival in
                router.google(festival)
            }
            EventsView(events: events, showEvents: calendarStore.showEvents)
        }
        .padding()

    }
}

struct FestivalsView: View {

    let action: (String) -> Void

    private var festivalGroups: [[String]] = []
    private let textPadding: CGFloat = 3
    private let textSpacing: CGFloat = 5
    private let textFont: Font = .caption2
    private let textStyle: NSFont.TextStyle = .caption2
    private let maxWidth: CGFloat = .mainWidth - 20

    init(festivals: [String], action: @escaping (String) -> Void) {
        self.action = action
        self.festivalGroups = convert(festivals: festivals)
    }

    var body: some View {
        if festivalGroups.isNotEmpty {
            VStack(alignment: .leading, spacing: textSpacing) {
                ForEach(festivalGroups, id: \.self) { group in
                    HStack(spacing: textSpacing) {
                        ForEach(group, id: \.self) { festival in
                            ScacleButton {
                                action(festival)
                            } label: {
                                Text(festival)
                                    .padding(textPadding)
                                    .background(Color.tagBackground)
                                    .appForeground(.appWhite)
                                    .clipShape(.rect(cornerRadius: 3))
                                    .font(textFont)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    func convert(festivals: [String]) -> [[String]] {
        var groups: [[String]] = []
        var group: [String] = []
        var groupWidth: CGFloat = 0

        for festival in festivals {
            let width =
                festival.size(withAttributes: [
                    .font: NSFont.preferredFont(forTextStyle: textStyle)
                ]).width + textSpacing
            let spacing = group.isEmpty ? 0 : textSpacing  // Add spacing only if not the first text

            if groupWidth + width + CGFloat(spacing) > maxWidth {
                groups.append(group)
                group = [festival]
                groupWidth = width
            } else {
                group.append(festival)
                groupWidth += width + CGFloat(spacing)
            }
        }

        if !group.isEmpty {
            groups.append(group)
        }

        return groups
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

            }
            .font(.caption2)
            .appForeground(.appSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(event.title)
        }
        .padding(5)
        .background(Color.card)
        .clipShape(.rect(cornerRadius: 5))
        .shadow(radius: 1, x: 1, y: 1)
        .padding(.horizontal, 3)
    }
}
