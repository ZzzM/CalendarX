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

    var body: some View {

        let image = Bundle.isReleaseVersion ? Image.release : Image.beta

        VStack {
            TitleView {
                Text(L10n.Settings.about)
            } leftItems: {
                ScacleImageButton(image: .backward) {
                    router.pop()
                }
            } rightItems: {
                ScacleImageButton(image: .feedback) {
                    router.open(AppLink.gitHub)
                }
            }

            Image(nsImage: NSApp.applicationIconImage)

            Text(Bundle.appName)
                .font(.title)
                .bold()

            HStack {
                Text(L10n.Updater.version)
                Text(Bundle.appVersionName)

                image
                    .appForeground(.accentColor)

            }
            .appForeground(.appSecondary)

            Spacer()
            Text(Bundle.copyright)
                .font(.footnote)
                .appForeground(.appSecondary)
        }
        .frame(height: .mainHeight, alignment: .top)
        .padding()
    }
}
