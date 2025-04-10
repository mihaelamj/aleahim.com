import Foundation
import Ignite
import CVBuilder

@main
struct IgniteWebsite {
    static func main() async {
        var site = AleahimSite()

        do {
            try await site.publish()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct AleahimSite: Site {
    let mmcv = CV.createForMihaela()
    
    var name = "Aleahim.com"
    var titleSuffix = " – Mihaela's Site"
    var url = URL(static: "https://www.aleahim.com")
    var builtInIconsEnabled = true
    
    var syntaxHighlighterConfiguration: SyntaxHighlighterConfiguration = .init(languages: [.swift, .python, .ruby])

    var author = "Mihaela Mihaljevic"

    var homePage = Home()
    var layout = MainLayout()
    
    var staticPages: [any StaticPage] {
        return Page.all
    }
}
