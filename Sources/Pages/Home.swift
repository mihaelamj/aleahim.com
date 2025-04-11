import Foundation
import Ignite

struct Home: StaticPage {
    var title = "Mihaela's Blog"
    var layout: any Layout = MainLayout()

    var body: some HTML {
        Text("Mihaela's Apple Dev Blog")
            .font(.title1)
    }
}
