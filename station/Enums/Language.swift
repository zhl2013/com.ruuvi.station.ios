import Foundation

enum Language: String, CaseIterable {
    case english = "EN"
    case russian = "RU"
}

extension Language {
    var name: String {
        switch self {
        case .english:
            return "Language.English".localized()
        case .russian:
            return "Language.Russian".localized()
        }
    }
}