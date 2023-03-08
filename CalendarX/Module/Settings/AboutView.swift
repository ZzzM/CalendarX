//
//  AboutView.swift
//  CalendarX
//
//  Created by zm on 2023/3/1.
//

import SwiftUI

struct AboutView: View {
    
    var body: some View {
        VStack {
            
            TitleView {
                Text(L10n.Settings.about)
            } actions: {
                ScacleImageButton(image: .close, action: Router.backSettings)
            }
            
            Image(nsImage: NSApp.applicationIconImage)
            
            Text(AppInfo.name).bold()
            
            Group {
                
                ScacleButton(action: { NSWorkspace.open(CalLink.gitHub) }) {
                    Text("GitHub for \(AppInfo.name)")
                        .foregroundColor(.accentColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                        .background(Capsule().stroke(Color.accentColor))
                }

                ScacleCapsuleButton(title: L10n.Settings.checkForUpdates,
                                    foregroundColor: .white,
                                    backgroundColor: .accentColor,
                                    action: Updater.checkForUpdates)
            
            }
            .font(.caption2)
            .frame(width: .mainWidth / 2.5)

            Group {
                Text(L10n.Settings.version) + Text(Updater.version)
                
                Spacer()
                
                Text("Copyright © 2020 ZzzM. All rights reserved.")
            }
            .font(.footnote)
            .foregroundColor(.secondary)
            
        }
        .frame(height: .mainHeight, alignment: .top)
    }
}
