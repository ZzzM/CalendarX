//
//  SettingsScreen.swift
//  CalendarX
//
//  Created by zm on 2022/1/26.
//

import SwiftUI
import Combine
import CalendarXShared

struct SettingsScreen: View {
    
    @ObservedObject
    var viewModel: SettingsViewModel

    var body: some View {
        
        VStack(spacing: 15) {

            TitleView {
                Text( L10n.Settings.title).onTapGesture {
                    Router.back()
                }
            } leftItems: {
                EmptyView()
            } rightItems: {
                ScacleImageButton(image: .quit, action: AlertViewModel.exit)
                    .focusDisabled()
            }

            Section {
                appearanceRow
                calendarRow
                languageRow
                memubarRow
                autoRow
                launchRow
                recommendRow
                aboutRow
            }

            
        }
        .frame(height: .mainHeight, alignment: .top)
        .padding()

    }

}

extension SettingsScreen {
    
    var appearanceRow: some View {
        SettingsRow(title: L10n.Settings.appearance, detail: {}, action: Router.toAppearanceSettings)
    }
    
    var calendarRow: some View {
        SettingsRow(title:  L10n.Settings.calendar, detail: {}, action: Router.toCalendarSettings)
    }

    var languageRow: some View {
        SettingsPickerRow(title: L10n.Settings.language,
                           items: Language.allCases, width: 70,
                           selection:  $viewModel.language) { Text($0.title) }
    }

    var memubarRow: some View {
        SettingsRow(title: L10n.Settings.menubarStyle,
                    detail: {Text(viewModel.menubarStyle.title) },
                    action: Router.toMenubarSettings)
    }
    
    var launchRow: some View {
        AppToggle { Text(L10n.Settings.launchAtLogin).font(.title3) }
            .checkboxStyle()
    }

    
    @ViewBuilder
    var autoRow: some View {
        
        let isOn = Binding(
            get: viewModel.getNotificationStatut,
            set: viewModel.setNotificationStatut
        )

        Toggle(isOn: isOn) { Text(L10n.Settings.auto).font(.title3) }
            .checkboxStyle()
        
    }
    
    var recommendRow: some View {
        SettingsRow(title: L10n.Settings.recommendations, detail: {}, action: Router.toRecommendations)
    }
    
    var aboutRow: some View {
        SettingsRow(title: L10n.Settings.about, detail: {}, action: Router.toAbout)
    }
    
}


extension SettingsScreen {
    
    var versionRow: some View {
        Group {
            Text(L10n.Settings.version) + Text(Updater.version)
        }
        .font(.footnote)
        .appForeground(.accentColor)
    }
}

struct SettingsRow<Content: View>: View {
    
    let title: LocalizedStringKey, titleFont: Font, showArrow: Bool

    @ViewBuilder
    let detail: () -> Content
    
    let action: VoidClosure
    
    init(title: LocalizedStringKey,
         titleFont: Font = .title3,
         showArrow: Bool = true,
         @ViewBuilder detail: @escaping () -> Content,
         action: @escaping VoidClosure) {
        self.title = title
        self.titleFont = titleFont
        self.showArrow = showArrow
        self.detail = detail
        self.action = action
    }
    
    var body: some View {
        
        HStack {
            Text(title)
                .font(titleFont)
            Spacer()
            
            Group {
                detail()
                if showArrow {
                    Image.rightArrow.font(titleFont)
                }
            }
            .appForeground(.appSecondary)

        }
        .contentShape(.rect)
        .onTapGesture(perform: action)
        
    }
}

struct SettingsPickerRow<Item: Hashable, Label: View>: View {
    
    let title: LocalizedStringKey, items: [Item], width: CGFloat
    
    @Binding
    var selection: Item
    
    @ViewBuilder
    let itemLabel: (Item) -> Label
    
    @State
    private var isPresented = false
    
    private let pref = Preference.shared
    
    init(title: LocalizedStringKey,
         items: [Item],
         width: CGFloat = .popoverWidth,
         selection: Binding<Item>,
         @ViewBuilder itemLabel:  @escaping (Item) -> Label) {
        self.title = title
        self.items = items
        self.width = width
        self._selection = selection
        self.itemLabel = itemLabel
    }
    
    var body: some View {
        
        HStack {
            Text(title).font(.title3)
            Spacer()
            ScacleButtonPicker(items: items,
                               tint: pref.accentColor,
                               width: width,
                               locale: pref.locale,
                               colorScheme: pref.colorScheme,
                               selection: $selection,
                               isPresented: $isPresented,
                               label: {
                HStack {
                    itemLabel(selection).appForeground(.appSecondary)
                    RotationArrow(isPresented: $isPresented)
                }
            }, itemLabel: itemLabel)
        }
    }
}

