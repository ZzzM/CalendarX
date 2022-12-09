//
//  TitleView.swift
//  CalendarX
//
//  Created by zm on 2022/12/9.
//

import SwiftUI

struct TitleView<Title: View, Content: View>: View {
    
    let title: () -> Title
    
    @ViewBuilder
    let actions: () -> Content
    
    var body: some View {
        ZStack {
            title().font(.title2)
            HStack(content: actions)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}


