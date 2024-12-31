//
//  AboutScreen.swift
//  CalendarX
//
//  Created by zm on 2023/3/1.
//

import CalendarXLib
import SwiftUI

struct AboutScreen: View {

    @EnvironmentObject
    private var router: Router
    
    private let updater: Updater
    
    init(updater: Updater) {
        self.updater = updater
    }
    
    var body: some View {
        VStack {
            TitleView {
                Text(L10n.Settings.about)
            } leftItems: {
                ScacleImageButton(image: .backward) {
                    router.pop()
                }
            } rightItems: {
                ScacleImageButton(image: .house) {
                    router.open(AppLink.gitHub)
                }
            }

            Image(nsImage: NSApp.applicationIconImage)

            Text(Bundle.appName).bold()

            Group {
                Text(L10n.Settings.version) + Text(Bundle.appDisplayVersion)
            }
            .font(.footnote)
            .appForeground(.appSecondary)

            ScacleCapsuleButton(
                title: L10n.Settings.checkForUpdates,
                foregroundColor: .white,
                backgroundColor: .accentColor,
                action: updater.checkForUpdates
            )
            .font(.caption2)
            .frame(width: .mainWidth / 2.5)

            Spacer()
            Text(Bundle.copyright)
                .font(.footnote)
                .appForeground(.appSecondary)
        }
        .frame(height: .mainHeight, alignment: .top)
        .padding()
    }
}
