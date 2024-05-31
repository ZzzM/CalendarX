//
//  MenubarStyleScreen.swift
//  CalendarX
//
//  Created by zm on 2022/10/27.
//

import SwiftUI
import Combine
import CalendarXShared


struct MenubarStyleScreen: View {
    
    @StateObject
    private var viewModel = MenubarViewModel()
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            TitleView {
                Text(L10n.Settings.menubarStyle)
            } leftItems: {
                ScacleImageButton(image: .backward, action: Router.back)
            } rightItems: {
                ScacleImageButton(image: .save, action: viewModel.save)
            }
            
            Picker(selection: $viewModel.style) {
                ForEach(MenubarStyle.allCases, id: \.self) {
                    Text($0.title)
                }
            } label: {
                EmptyView()
            }
            .pickerStyle(.segmented)
            
            ZStack {
                switch viewModel.style {
                case .icon: IconStyleView(iconType: $viewModel.iconType)
                case .date: DateStyleView(viewModel: viewModel)
                }
            }
            .frame(maxHeight: .infinity)
            
        }
        .focusable(false)
        .padding()
        
    }
    
    
}

struct IconStyleView: View {
    
    @Binding
    var iconType: IconType
    
    
    var body: some View {

        VStack {
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: .init(spacing: 0), count: 3), spacing: 0) {
                    
                    ForEach(IconType.allCases, id: \.self) { type in
                        
            
                        ScacleButton {
                            iconType = type

                        } label: {
                            
                            ZStack {
                                
                                if type == iconType {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.accentColor, lineWidth: 3)
                                }
                                
                                Text(type.title)
                                    .font(.caption2)
                                    .offset(y: 1)
                                
                                Image(nsImage: type.nsImage)
                                    .resizable()
                                    .frame(width: type.size.width,
                                           height: type.size.height)
                                
                            }
                            .sideLength(40)
                            .padding()
                        }
                    }
                }.padding()
            }
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
                .padding(.vertical)
            
            ScrollView {
                
                gridView(types: viewModel.shownTypes,
                         background: Color.tagBackground,
                         onTapGesture: viewModel.shownTagTapped,
                         onDrop: viewModel.onDrop)
                
                gridView(types: viewModel.hiddenTypes,
                         background: .disable,
                         onTapGesture: viewModel.hiddenTagTapped)
                
                Toggle(isOn: $viewModel.use24h) { Text(L10n.MenubarStyle.use24).font(.title3) }
                    .checkboxStyle()
                    .padding(.top)
                
                Toggle(isOn: $viewModel.showSeconds) { Text(L10n.MenubarStyle.showSeconds).font(.title3) }
                    .checkboxStyle()
                
            }
            
            
        }
    }
    private func gridView(types:  [DTType],
                          background: Color,
                          onTapGesture: @escaping (DTType) -> Void,
                          onDrop: ((NSItemProvider?,  DTType) -> Bool)? = .none) -> some View {
        
        LazyVGrid(columns: .init(repeating: .init(), count: 4)) {
            ForEach(types, id: \.self) { type in
                if onDrop != nil {
                    tagView(type, foregroundColor: .white, background: background, onTapGesture: onTapGesture)
                        .onDrag { viewModel.onDrag(type) }
                        .onDrop(of: [.text], isTargeted: .none) {
                            onDrop! ($0.first, type)
                        }
                } else {
                    tagView(type, foregroundColor: .white, background: background, onTapGesture: onTapGesture)
                        .onDrag { viewModel.onDrag(type) }
                }
                
            }
        }
    }
    
    private func tagView(_ type: DTType,
                         foregroundColor: Color,
                         background: Color,
                         onTapGesture: @escaping (DTType) -> Void) -> some View {
        
        Text(viewModel.transform(type))
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .frame(width: 55)
            .padding(5)
            .background(background)
            .appForeground(foregroundColor)
            .clipShape(.capsule)
            .onTapGesture {
                onTapGesture(type)
            }
        
    }
    
}

