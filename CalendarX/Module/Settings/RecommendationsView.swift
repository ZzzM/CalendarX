//
//  RecommendationsView.swift
//  CalendarX
//
//  Created by zm on 2022/12/9.
//

import SwiftUI

struct RecommendationsView: View {
    
    private let apps: [XApp] = Bundle.main.json2Object(from: "apps") ?? []
    
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
    
    let app: XApp
    
    var body: some View {
        HStack {
            Image(app.name).resizable().square(60)
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(app.name)
                    ScacleButton {
                        NSWorkspace.open(app.link)
                    } label: {
                        Image.gitHub.square(15)
                    }
                }
                Text(app.about).font(.footnote).foregroundColor(.secondary).lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

struct XApp: Decodable, Identifiable {
    var id: String { name }
    let name: String, about: String, link: String
}
