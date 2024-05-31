//
//  AboutScreen.swift
//  CalendarX
//
//  Created by zm on 2023/3/1.
//

import SwiftUI
import CalendarXShared

struct AboutScreen: View {
    
    var body: some View {
        VStack {
            
            TitleView {
                Text(L10n.Settings.about)
            } leftItems: {
                ScacleImageButton(image: .backward, action: Router.back)
            } rightItems: {
                EmptyView()
            }


            Image(nsImage: NSApp.applicationIconImage)

            Text(AppBundle.name).bold()

            Group {
                

                ScacleButton {
                    NSWorkspace.open(AppLink.gitHub)
                } label: {
                    Text("GitHub for \(AppBundle.name)")
                        .appForeground(.accentColor)
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
                
                Text(AppBundle.copyright)
            }
            .font(.footnote)
            .appForeground(.appSecondary)

        }
        .frame(height: .mainHeight, alignment: .top)
        .padding()

    }
}
