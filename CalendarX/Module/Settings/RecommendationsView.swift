//
//  RecommendationsView.swift
//  CalendarX
//
//  Created by zm on 2022/12/9.
//

import SwiftUI

struct RecommendationsView: View {
    
    private let apps: [CalApp] = Bundle.main.json2Object(from: "apps") ?? []
    
    var body: some View {
        
        VStack {
            
            TitleView {
                Text(L10n.Settings.recommendations)
            } actions: {
                ScacleImageButton(image: .close, action: Router.backSettings)
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
    
    let app: CalApp
    
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
                        Image.gitHub.sideLength(15).foregroundColor(.secondary)
                    }
                }
                Text(app.about).font(.caption2).foregroundColor(.secondary).lineLimit(2)
            }
        }
        .padding(5)
        .background(Color.card)
        .cornerRadius(5)
        .shadow(radius: 1, x: 1, y: 1)
        .padding(.horizontal, 3)
    
        
        
    }
}

struct CalApp: Decodable, Identifiable {
    var id: String { name }
    let name: String, about: String, link: String
}
