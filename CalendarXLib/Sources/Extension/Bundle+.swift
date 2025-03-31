//
//  Bundle+.swift
//  CalendarX
//
//  Created by zm on 2022/2/21.
//

import Foundation

extension Bundle {

    func jsonModel<T: Decodable>(resource: String) -> T? {
        if let url = url(forResource: resource, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let model = try? JSONDecoder().decode(T.self, from: data)
        {
            model
        } else {
            .none
        }
    }

}

extension Bundle {

    public static var appName: String {
        main.object(forInfoDictionaryKey: "CFBundleName") as! String
    }

    public static var appVersionName: String {
        main.object(forInfoDictionaryKey: "AppVersionName") as? String ?? appVersion
    }

    public static var appVersion: String {
        main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }

    public static var appBuild: String {
        main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }

    public static var identifier: String {
        main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    }

    public static var copyright: String {
        main.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as! String
    }

}

extension ProcessInfo {
    public static var osVersionName: String {
        
        let os = processInfo.operatingSystemVersion
        
        
        var version = "\(os.majorVersion).\(os.minorVersion)"
        if !os.patchVersion.isMultiple(of: 0) {
            version += ".\(os.patchVersion)"
        }
   
        var osString = ProcessInfo.processInfo.operatingSystemVersionString.dropLast()
        var value = osString.removeLast()
        var build = ""
       
        while value.isNumber || value.isUppercase {
            build = String(value) + build
            value = osString.removeLast()
        }
        
        return "\(version) (\(build))"
    }
}
