//
//  MenubarViewModel.swift
//  CalendarX
//
//  Created by zm on 2023/2/13.
//

import SwiftUI
import CalendarXShared

class MenubarViewModel: ObservableObject {

    private let pref = MenubarPreference.shared

    @Published
    var style = MenubarPreference.shared.style

    // Icon Style
    @Published
    var iconType = MenubarPreference.shared.iconType
    
    // Date&Time Style

    // Use a 24-hour clock
    @Published
    var use24h = MenubarPreference.shared.use24h

    //Display the time with seconds
    @Published
    var showSeconds = MenubarPreference.shared.showSeconds

    @Published
    var shownTypes = MenubarPreference.shared.shownTypes

    @Published
    var hiddenTypes = MenubarPreference.shared.hiddenTypes


    var dateTitle: String {
        shownTypes.generateTitle(transform: transform)
    }

    func save() {

        if .date == style {
            pref.showSeconds = showSeconds
            pref.use24h = use24h
            pref.shownTypes = shownTypes
            pref.hiddenTypes = hiddenTypes
        }
        else if .icon == style {
            pref.iconType = iconType
        }

        pref.style = style

        Router.back()

        NotificationCenter.default.post(name: .titleStyleDidChanged, object: .none)
    }


}

//MARK: Date&Time Style
extension  MenubarViewModel {

    func transform(_ type: DTType) -> String {
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

    func shownTagTapped(_ type: DTType) {
        guard shownTypes.count > 1 else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self, let index = shownTypes.firstIndex(of: type) else { return }
            shownTypes.remove(at: index)
            hiddenTypes.append(type)
        }
    }

    func hiddenTagTapped(_ type: DTType) {
        DispatchQueue.main.async { [weak self] in
            guard let self, let index = hiddenTypes.firstIndex(of: type) else { return }
            hiddenTypes.remove(at: index)
            shownTypes.append(type)
        }
    }

    func onDrop(provider: NSItemProvider?, type: DTType) -> Bool {

        provider?.loadObject(ofClass: NSString.self) { reading, error in

            guard let typeRawValue = reading as? String else { return }

            DispatchQueue.main.async { [weak self] in

                guard let self, let to = shownTypes.firstIndex(of: type) else { return }

                if let from = shownTypes.firstIndex(where: { typeRawValue == $0.rawValue }) {
                    shownTypes.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? (to + 1): to)
                }
                else if let from = hiddenTypes.firstIndex(where: { typeRawValue == $0.rawValue }) {
                    let type = hiddenTypes[from]
                    shownTypes.insert(type, at: to)
                    hiddenTypes.remove(at: from)
                }

            }
        }
        return false
    }

    func onDrag(_ type: DTType) -> NSItemProvider {
        return NSItemProvider(object: type.rawValue as NSString)
    }

}
