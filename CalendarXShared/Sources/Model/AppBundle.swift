import Foundation
enum AppBundleKey: String {
    case build = "CFBundleVersion",
         version = "CFBundleShortVersionString",
         identifier = "CFBundleIdentifier",
         name = "CFBundleName",
         commitHash = "CommitHash",
         commitDate = "CommitDate",
         copyright = "NSHumanReadableCopyright"
}

public struct AppBundle {

    private static subscript(key: AppBundleKey) -> String {
        Bundle.main.infoDictionary?[key.rawValue] as? String ?? "none"
    }
    public static let name = Self[.name]
    public static let version = Self[.version]
    public static let identifier = Self[.identifier]
    public static let commitHash = Self[.commitHash]
    public static let commitDate = Self[.commitHash]
    public static let copyright = Self[.copyright]
}
