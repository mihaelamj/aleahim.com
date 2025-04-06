import Foundation
import Ignite

enum Page: String, CaseIterable {
    case blog = "Home"
    case about = "About"
    case cv = "CV"
    case contact = "Contact"
    
    @MainActor
    var page: any StaticPage {
        switch self {
        case .blog: return Home()
        case .about: return About()
        case .cv: return CVPage()
        case .contact: return Contact()
        }
    }
    
    @MainActor
    static var all: [any StaticPage] {
        Self.allCases.map { $0.page }
    }
}
