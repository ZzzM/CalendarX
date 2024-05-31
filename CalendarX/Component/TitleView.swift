//
//  TitleView.swift
//  CalendarX
//
//  Created by zm on 2022/12/9.
//

import SwiftUI

struct TitleView<Title: View, LeftItems: View, RightItems: View>: View {
    
    let title: () -> Title
    
    @ViewBuilder
    let leftItems: () -> LeftItems

    @ViewBuilder
    let rightItems: () -> RightItems

    
    var body: some View {
        ZStack {
            
            HStack(content: leftItems)
                .frame(maxWidth: .infinity, alignment: .leading)

            title()
                .font(.title2)
                .appForeground(.accentColor)

            HStack(content: rightItems)
                .frame(maxWidth: .infinity, alignment: .trailing)

        }

    }
}


