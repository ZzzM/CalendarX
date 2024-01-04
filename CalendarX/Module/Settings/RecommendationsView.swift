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
        
    }
}

struct AppView: View {
    
    let app: AppInfo

    var body: some View {
        HStack {
            Image(app.name).resizable().sideLength(60)
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(app.name)
                    Spacer()
                    ScacleButton {
                        NSWorkspace.open(app.link)
                    } label: {
                        Image.gitHub.sideLength(15)
                            .appForeground(.appSecondary)
                    }
                    .hoverEffect

                }
                Text(app.about).font(.caption2).appForeground(.appSecondary).lineLimit(2)
            }
        }
        .padding(5)
        .background(Color.card)
        .clipShape(.rect(cornerRadius: 5))
        .shadow(radius: 1, x: 1, y: 1)
        .padding(.horizontal, 3)
    
        
        
    }
}

