//
//  MenubarViewModel.swift
//  CalendarX
//
//  Created by zm on 2023/2/13.
//

import SwiftUI

class MenubarViewModel: ObservableObject {

    private let pref = MenubarPreference.shared
    
    @Published
    var style = MenubarPreference.shared.style
    
    // Text Style
    @Published
    var text = MenubarPreference.shared.text
    
    // Date&Time Style
    
    // Use a 24-hour clock
    @Published
    var use24h = MenubarPreference.shared.use24h
    
    //Display the time with seconds
    @Published
    var showSeconds = MenubarPreference.shared.showSeconds
    
    @Published
    private var shownTypes = MenubarPreference.shared.shownTypes
    
    @Published
    private var hiddenTypes = MenubarPreference.shared.hiddenTypes
    
    var shownTags: [DTTag] { Array(shownTypes.enumerated()) }
    
    var hiddenTags: [DTTag] { Array(hiddenTypes.enumerated()) }
    
    var dateTitle: String {
        L10n.dateTitle(types: shownTypes) { tagTitle($0) }
    }
    
    var disabled: Bool {
        switch style {
        case .text: return text.isEmpty
        default: return false
        }
    }
    
    func save() {
        
        if style == .date {
            pref.showSeconds = showSeconds
            pref.use24h = use24h
            pref.shownTypes = shownTypes
            pref.hiddenTypes = hiddenTypes
        }
        else if style == .text {
            pref.text = text
        }
        
        pref.style = style
        
        Router.backSettings()
        
        NotificationCenter.default.post(name: .titleStyleDidChanged, object: .none)
    }
    

    
}

//MARK: Date&Time Style
extension  MenubarViewModel {

    func tagTitle(_ type: DTType) -> String {
        switch type {
        case .lm: return "正月"
        case .ld: return "十五"
        case .sm: return L10n.inChinese ? "2月" : "Feb"
        case .sd: return L10n.inChinese ? "5日" : "5"
        case .e: return L10n.inChinese ? "周日" : "Sun"
        case .a: return L10n.inChinese ? "下午" : "PM"
        case .t: return  (use24h ? "20:30":"8:30") + (showSeconds ? ":30":"") //d 24, e sec
        }
    }
    
    func shownTagTapped(_ tag: DTTag) {
        guard shownTypes.count > 1 else { return }
        Task { @MainActor in
            guard shownTypes.indices ~= tag.offset else { return }
            withAnimation {
                shownTypes.remove(at: tag.offset)
                hiddenTypes.append(tag.element)
            }
        }
    }
    
    func hiddenTagTapped(_ tag: DTTag) {
        Task { @MainActor in
            guard hiddenTypes.indices ~= tag.offset else { return }
            withAnimation {
                hiddenTypes.remove(at: tag.offset)
                shownTypes.append(tag.element)
            }
        }
    }
    
    func onDrop(provider: NSItemProvider?, to: Int) -> Bool {
        
        provider?.loadObject(ofClass: NSString.self) { reading, error in
        
            guard let reading = reading as? String else { return }
            guard let obj = reading.toObject(DTIndex.self) else { return }
            
            Task { @MainActor in
                withAnimation(.easeInOut) {
                    let isShown = obj.isShown, from = obj.index
                    
                    if isShown {
                        self.shownTypes.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? (to + 1): to)
                    } else {
                        let type = self.hiddenTypes[from]
                        self.shownTypes.insert(type, at: to)
                        self.hiddenTypes.remove(at: from)
                    }
                }
            }
        }
        
        return false
    }
    
    func onDrag(_ index: Int) -> NSItemProvider {
        NSItemProvider(object: #"{"isShown":true,"index":\#(index)}"# as NSString)
    }
    

}
