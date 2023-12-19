//
//  AlertView.swift
//  CalendarX
//
//  Created by zm on 2023/3/5.
//

import SwiftUI
import Combine

struct AlertView: View {

    @ObservedObject
    var alert: AlertAction

    var body: some View {


        ZStack(alignment: .bottom) {

            Color.black
                .opacity(alert.isPresented ? 0.5: 0)
                .onTapGesture(perform: alert.dismiss)


            if alert.isPresented {
                VStack {

                    alert.image.font(.largeTitle).appForeground(.accentColor)
                    Text(alert.message).font(.title3).multilineTextAlignment(.center).padding(.vertical, 5)

                    ScacleCapsuleButton(title: alert.yes, foregroundColor: .white, backgroundColor: .accentColor, action: alert.action)
                    ScacleCapsuleButton(title: alert.no, foregroundColor: .white, backgroundColor: .appSecondary, action: alert.dismiss)

                }
                .padding()
                .background(Color.card.clipShape(.rect(cornerRadius: 5)))
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .padding()
            }
        }
    }
}
