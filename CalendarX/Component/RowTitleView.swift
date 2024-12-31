//
//  RowTitleView.swift
//  CalendarX
//
//  Created by zm on 2023/2/18.
//

import SwiftUI

struct RowTitleView: View {
    let title: LocalizedStringKey, font: Font?

    var body: some View {
        Text(title)
            .font(font)
            .frame(maxWidth: .infinity, alignment: .leading)
            .appForeground(font != .none ? .appPrimary : .appSecondary)
    }
}
