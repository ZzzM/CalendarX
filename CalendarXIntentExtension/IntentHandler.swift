//
//  IntentHandler.swift
//  CalendarXIntentExtension
//
//  Created by zm on 2024/5/30.
//

import Intents
import CalendarXShared

class IntentHandler: INExtension {

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}

extension IntentHandler: WidgetConfigurationIntentHandling  {

    func defaultLightAccentColor(for intent: WidgetConfigurationIntent) -> WidgetColor? {
        intent.colorItem(from: Bundle.defaultLightAccent)
    }

    func defaultLightBackgroundColor(for intent: WidgetConfigurationIntent) -> WidgetColor? {
        intent.colorItem(from: Bundle.defaultLightBackground)
    }

    func defaultDarkAccentColor(for intent: WidgetConfigurationIntent) -> WidgetColor? {
        intent.colorItem(from: Bundle.defaultDarkAccent)
    }

    func defaultDarkBackgroundColor(for intent: WidgetConfigurationIntent) -> WidgetColor? {
        intent.colorItem(from: Bundle.defaultDarkBackground)
    }

}

extension IntentHandler {


    func provideLightAccentColorOptionsCollection(for intent: WidgetConfigurationIntent) async throws -> INObjectCollection<WidgetColor> {
        let items = Bundle.lightAccent.map(intent.colorItem)
        return INObjectCollection(items: items)
    }
    

    func provideLightBackgroundColorOptionsCollection(for intent: WidgetConfigurationIntent) async throws -> INObjectCollection<WidgetColor> {
        let items = Bundle.lightBackground.map(intent.colorItem)
        return INObjectCollection(items: items)
    }
    

    func provideDarkAccentColorOptionsCollection(for intent: WidgetConfigurationIntent) async throws -> INObjectCollection<WidgetColor> {
        let items = Bundle.darkAccent.map(intent.colorItem)
        return INObjectCollection(items: items)
    }
    
    func provideDarkBackgroundColorOptionsCollection(for intent: WidgetConfigurationIntent) async throws -> INObjectCollection<WidgetColor> {
        let items = Bundle.darkBackground.map(intent.colorItem)
        return INObjectCollection(items: items)
    }

}
