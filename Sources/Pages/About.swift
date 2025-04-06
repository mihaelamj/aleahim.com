import Foundation
import Ignite
import mycv

struct About: StaticPage {
    var title = "About me"
    
    let cv = CV.createForMihaela()

    var body: some HTML {
        Text("About Mihaela")
            .font(.title1)
    }
}
