import Foundation
import Ignite

struct About: StaticPage {
    var title = "About me"

    var body: some HTML {
        Text("About Mihaela")
            .font(.title1)
    }
}
