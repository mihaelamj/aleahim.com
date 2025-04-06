import Foundation
import Ignite

struct Home: StaticPage {
    var title = "Mihaela's Blog"

    var body: some HTML {
        Text("Mihaela's Apple Dev Blog")
            .font(.title1)
    }
}
