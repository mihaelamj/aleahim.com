import Foundation
import Ignite

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
    var name = "Aleahim.com"
    var titleSuffix = " – Mihaela's Site"
    var url = URL(static: "https://www.aleahim.com")
    var builtInIconsEnabled = true

    var author = "Mihaela Mihaljevic"

    var homePage = Home()
    var layout = MainLayout()
}
