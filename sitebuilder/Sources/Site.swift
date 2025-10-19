import Foundation
import Ignite
import CVBuilder

@main
struct IgniteWebsite {
    static func main() async {
        var site = AleahimSite()

        do {
            // Generate the CV Markdown before publishing the site
            generateMihaelasCVMarkdownInContentFolder()
            
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
    var url = URL(static: "https://aleahim.com")
    var builtInIconsEnabled = true
    
    var syntaxHighlighterConfiguration: SyntaxHighlighterConfiguration = .init(languages: [.swift, .python, .ruby])
    
    // Add feed configuration for blog posts
    var feedConfiguration = FeedConfiguration(
        mode: .full,
        contentCount: 20,
        image: .init(url: "/images/icon32.png", width: 32, height: 32)
    )
    
    var author = "Mihaela Mihaljevic"

    var head: [any HeadElement] {
        [
            Analytics(.custom("""
            <script defer src="https://cloud.umami.is/script.js" data-website-id="1ee8d39f-4184-4d60-89a3-13131860112a"></script>
            """))
        ]
    }

    var homePage = Home()
    var layout = MainLayout()
    
    var staticPages: [any StaticPage] {
        print("Pages:", Page.all.count)
        return Page.all
    }
    
    // Add article pages for Markdown content
    var articlePages: [any ArticlePage] {
        CoreAnimation3DCube()
        CVBuilder()
        ExtremePackages()
        LoggingMiddleware()
        ExtremePackagingOpenAPI()
    }
}

