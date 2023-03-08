//
//  MenubarSettingsView.swift
//  CalendarX
//
//  Created by zm on 2022/10/27.
//

import SwiftUI
import Combine


struct MenubarSettingsView: View {
    
    @StateObject
    private var viewModel = MenubarViewModel()

    var body: some View {
        
        VStack(spacing: 10) {
            
            TitleView {
                Text(L10n.Settings.menubarStyle)
            } actions: {
                ScacleImageButton(image: .close, action: Router.backSettings)
            }
            
            SegmentedPicker(tabs: MenubarStyle.allCases, selection: $viewModel.style) {
                Text($0.title)
            }
            
            ZStack {
                switch viewModel.style {
                case .default: DefaultStyleView()
                case .text: TextStyleView(text: $viewModel.text)
                case .date: DateStyleView(viewModel: viewModel)
                }
            }
            .frame(maxHeight: .infinity)
            
            
            ScacleCapsuleButton(title: L10n.MenubarStyle.save,
                                foregroundColor: .white,
                                backgroundColor: viewModel.disabled ? .disable: .accentColor,
                                action: viewModel.save)
            .frame(width: .mainWidth/2)
            .disabled(viewModel.disabled)
            
            
        }
        .focusable(false)
        
    }
    
    
}

struct DefaultStyleView: View {
    var body: some View {
        Image.calendar.sideLength(30)
        
        Text(Date().day.description)
            .font(.title3)
            .offset(y: 5)
    }
}


struct TextStyleView: View {
    
    @Binding
    var text: String
    
    var body: some View {
        VStack {
            
            Text(text).font(.title3).frame(height: 30)
            
            TextField(AppInfo.name, text: $text.max())
                .textFieldStyle(.plain)
                .multilineTextAlignment(.center)
            
            
            Divider().padding(.horizontal)
            
            Text(L10n.MenubarStyle.tips)
                .font(.footnote)
                .foregroundColor(.secondary)
            
        }
    }
}


struct DateStyleView: View {
    
    @ObservedObject
    var viewModel: MenubarViewModel
    
    var body: some View {
        VStack {
            
            Text(viewModel.dateTitle)
                .font(.title3)
                .padding(.vertical, 5)
            
            ScrollView {
    
                gridView(tags: viewModel.shownTags,
                         background: .tagBackground,
                         onTapGesture: viewModel.shownTagTapped,
                         onDrop: viewModel.onDrop)
                
                gridView(tags: viewModel.hiddenTags,
                         background: .disable,
                         onTapGesture: viewModel.hiddenTagTapped)
                
                Toggle(isOn: $viewModel.use24h) { Text(L10n.MenubarStyle.use24).font(.title3) }
                    .checkboxStyle()
                    .padding(.top, 5)
                
                Toggle(isOn: $viewModel.showSeconds) { Text(L10n.MenubarStyle.showSeconds).font(.title3) }
                    .checkboxStyle()
                
            }
            
            
            
        }
    }
    
    private func gridView(tags:  [DTTag],
                          background: Color,
                          onTapGesture: @escaping (DTTag) -> Void,
                          onDrop: ((NSItemProvider?,  Int) -> Bool)? = .none) -> some View {
        
        LazyVGrid(columns: .init(repeating: .init(), count: 4)) {
            ForEach(tags, id: \.element) { tag in
                
                if onDrop != nil {
                    tagView(tag, foregroundColor: .accentColor, background: background, onTapGesture: onTapGesture)
                        .onDrag { viewModel.onDrag(tag.offset) }
                        .onDrop(of: [.utf8PlainText], isTargeted: .none) {
                            onDrop! ($0.first, tag.offset)
                        }
                } else {
                    tagView(tag, foregroundColor: .white, background: background, onTapGesture: onTapGesture)
                        .onDrag { viewModel.onDrag(tag.offset) }
                }
                
            }
        }
    }
    
    private func tagView(_ tag: DTTag,
                         foregroundColor: Color,
                         background: Color,
                         onTapGesture: @escaping (DTTag) -> Void) -> some View {
        
        Text(viewModel.tagTitle(tag.element))
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .frame(width: 55)
            .padding(5)
            .background(background)
            .foregroundColor(foregroundColor)
            .clipShape(Capsule())
            .onTapGesture {
                onTapGesture(tag)
            }
        
    }
    
}

