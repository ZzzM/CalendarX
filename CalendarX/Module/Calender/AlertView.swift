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
        
        Color.black
            .opacity(alert.isPresented ? 0.5: 0)
            .onTapGesture(perform: alert.dismiss)
        
        if alert.isPresented {
            VStack {
                Text(alert.title).bold().padding(.vertical, 5).foregroundColor(.accentColor)
                Text(alert.message).multilineTextAlignment(.center)
                HStack {
                    ScacleCapsuleButton(title: alert.no, foregroundColor: .white, backgroundColor: .secondary, action: alert.dismiss)
                    ScacleCapsuleButton(title: alert.yes, foregroundColor: .white, backgroundColor: .accentColor, action: alert.action)
                }
                .font(.caption2)
            }
            .padding()
            .frame(width: .mainWidth/2, alignment: .top)
            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.card).shadow(radius: 1, x: 1, y: 1))
            .transition(.move(edge: .bottom ).combined(with: .opacity))
        }
        
    }
}
