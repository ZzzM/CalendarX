//
//  RecommendationsView.swift
//  CalendarX
//
//  Created by zm on 2022/12/9.
//

import SwiftUI
import CalendarXShared

struct RecommendationsView: View {

    private let apps = Bundle.apps

    var body: some View {
        
        VStack {
            
            TitleView {
                Text(L10n.Settings.recommendations)
            } leftItems: {
                ScacleImageButton(image: .backward, action: Router.back)
            } rightItems: {
                EmptyView()
            }

            ScrollView {
                ForEach(apps) { app in
                  AppView(app: app)
                }
            }
            
        }
        .padding()

    }

}

struct AppView: View {
    
    let app: AppInfo

    var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                header
                Text(app.about)
                    .font(.callout)
                    .padding(2)
            }
            .padding(5)
            .background(Color.card)
            .clipShape(.rect(cornerRadius: 5))
            .shadow(radius: 1, x: 1, y: 1)
            .padding(.horizontal, 3)
            .hoverEffect
            .onTapGesture {
                NSWorkspace.open(app.link)
            }
    }

    var header: some View {
        HStack(spacing: 5) {
            Image(app.name).resizable().sideLength(.buttonWidth)
            VStack(alignment: .leading, spacing: 3) {
                Text(app.name).bold()
                Text(app.link)
                    .font(.caption2)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .appForeground(.secondary)
            }
        }

    }
}

