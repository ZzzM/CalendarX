//
//  AppearanceSettingsView.swift
//  CalendarX
//
//  Created by zm on 2023/2/17.
//

import SwiftUI
import CalendarXShared

struct AppearanceSettingsView: View {
    
    @ObservedObject
    var viewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 10) {

            TitleView {
                Text(L10n.Settings.appearance)
            } leftItems: {
                ScacleImageButton(image: .backward, action: Router.back)
            } rightItems: {
                EmptyView()
            }

            darkSection
            accentSection
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()

    }
    
}

extension AppearanceSettingsView {
    private var darkSection: some View {
        Section {
            Toggle(isOn: $viewModel.isSystem) { Text(L10n.Theme.system) }
                .appForeground(.appSecondary)
                .checkboxStyle()
            
            if viewModel.isShown {
                Toggle(isOn: $viewModel.isDark) { Text(L10n.Theme.dark) }
                    .appForeground(.appSecondary)
                    .checkboxStyle()
            }
            
        } header: {
            RowTitleView(title: L10n.Theme.dark, font: .title3)
        }
    }
}

extension AppearanceSettingsView {
    private var accentSection: some View {
        Section {
            HStack {
                Text(L10n.Appearance.hex)
                    .appForeground(.appSecondary)
                Spacer()
                
                if #available(macOS 12.0, *) {
                    hexLabel.textSelection(.enabled)
                } else {
                    hexLabel
                }
            }

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: .init(spacing: 0), count: 3), spacing: 0) {
                    ForEach(Appearance.palettes, id: \.self) {
                        colorRow($0)
                    }
                }
                .clipShape(.rect(cornerRadius: 5))
            }

        } header: {
            RowTitleView(title: L10n.Appearance.tint, font: .title3)
        }
        
    }
    
    private func colorRow(_ palette: [String]) -> some View {
        HStack(spacing: 0) {
            ForEach(palette, id: \.self) { hex in
                Button {
                    withAnimation {
                        viewModel.tint = hex
                    }
                } label: {
                    
                    Color(hex: hex)
                        .padding(hex == viewModel.tint ? 3:0)
                    
                }
                .aspectRatio(1, contentMode: .fit)
                .background(Color.white)
                .buttonStyle(.borderless)
            }
        }
    }
    
    private var hexLabel: some View {
        Text("#" + viewModel.tint)
            .font(.caption2)
            .frame(height: 20)
            .padding(.horizontal, 3)
            .background(Color.accentColor)
            .appForeground(.white)
            .clipShape(.rect(cornerRadius: 5))
    }
    
}
