//
//  AlertScreen.swift
//  CalendarX
//
//  Created by zm on 2023/3/5.
//

import SwiftUI
import Combine

struct AlertScreen: View {

    @ObservedObject
    var viewModel: AlertViewModel

    var body: some View {

        ZStack(alignment: .bottom) {

            Color.black
                .opacity(viewModel.isPresented ? 0.5: 0)
                .onTapGesture(perform: viewModel.dismiss)

            if viewModel.isPresented {
                VStack {

                    viewModel.image.font(.largeTitle).appForeground(.accentColor)

                    if let message = viewModel.message {
                        Text(message).font(.title3).multilineTextAlignment(.center).padding(.vertical, 5)
                    }

                    if let yes = viewModel.yes {
                        ScacleCapsuleButton(title: yes, foregroundColor: .white, backgroundColor: .accentColor, action: viewModel.action)
                    }

                    if let no = viewModel.no {
                        ScacleCapsuleButton(title: no, foregroundColor: .white, backgroundColor: .appSecondary, action: viewModel.dismiss)
                    }

                }
                .padding()
                .background(Color.card.clipShape(.rect(cornerRadius: 5)))
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .padding()
            }
        }
        .zIndex(1)
    }
}
