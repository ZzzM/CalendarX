//
//  File.swift
//  CalendarX
//
//  Created by zm on 2022/10/27.
//

import SwiftUI
import Combine

struct MenuBarSettingsView: View {

    @EnvironmentObject
    private var pref: Preference

    @State
    private var style = Preference.shared.menuBarStyle

    @State
    private var text = Preference.shared.menuBarText

    @State
    private var dateFormat = Preference.shared.menuBarDateFormat

    @State
    private var saved = false


    private var disabled: Bool {
        switch style {
        case .text: return text.isEmpty
        case .date: return dateFormat.isEmpty
        default: return false
        }
    }


    var body: some View {
        VStack(spacing: 10) {

            TitleView {
                Text(L10n.Settings.menuBarStyle)
            } actions: {
                ScacleImageButton(image: .close, action: Router.backSettings)
            }

            Picker(selection: $style) {
                ForEach(MenuBarStyle.allCases, id: \.self) {
                    Text($0.title)
                }
            } label: {
                EmptyView()
            }
           .pickerStyle(.segmented)


            ZStack {
                switch style {
                case .default: defaultContent()
                case .text: TextView(text: $text)
                case .date: DateFormatView(dateFormat: $dateFormat)
                }
            }
            .frame(maxHeight: .infinity)
            
            
            ScacleCapsuleButton(title: L10n.MenubarStyle.save,
                                foregroundColor: .white,
                                backgroundColor: disabled ? .secondary: .accentColor,
                                action: save)
            .frame(width: .mainWidth/2)
            .disabled(disabled)
            .onChange(of: saved, notification: .titleStyleDidChanged)
            
        }
        .focusable(false)

    }

    @ViewBuilder
    func defaultContent() -> some View {

        Image.menubarIcon.square(30)

        Text(Date().day.description)
            .font(.title3)
            .offset(y: 5)
    }



    func save() {

        if .date == style {
            pref.menuBarDateFormat = dateFormat
        }
        else if .text == style {
            pref.menuBarText = text
        }

        pref.menuBarStyle = style

        saved.toggle()
        
        Router.backSettings()
    }

}


struct TextView: View {

    @Binding
    var text: String

    var body: some View {
        VStack {

            Text(text).font(.title3)
            
            TextField(AppInfo.name, text: $text)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.center)
                .onReceive(Just(text)) { _ in
                    text.limit()
                }
            
            Divider().padding(.horizontal)

            Text(L10n.MenubarStyle.tips)
                .font(.footnote)
                .foregroundColor(.secondary)

        }
    }
}

struct DateFormatView: View {

    @Binding
    var dateFormat: String

    var body: some View {
        VStack {

            Text(L10n.dateString(from: dateFormat)).font(.title3)

            TextField(AppInfo.dateFormat, text: $dateFormat)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.center)
                .onReceive(Just(dateFormat)) { _ in
                    dateFormat.limit()
                }
            
            Divider().padding(.horizontal)

            Text(L10n.MenubarStyle.tips)
                .font(.footnote)
                .foregroundColor(.secondary)

        }
    }
}

extension String {
    mutating func limit(_ upper: Int = 30) {
        if count > upper {
            self = self.prefix(upper) + ""
        }
    }
}
