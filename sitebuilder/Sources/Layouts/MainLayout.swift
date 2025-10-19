import Foundation
import Ignite

struct MainLayout: Layout {

    var body: some Document {
        Head {
            Analytics(.custom("""
            <script defer src="https://cloud.umami.is/script.js" data-website-id="1ee8d39f-4184-4d60-89a3-13131860112a"></script>
            """))
        }

        Body {
            NavBar(name: "Aleahim")
                .padding(.bottom, 80)

            content

            Section {
                SocialFooter()
                    .margin(.bottom, 80)
            }
        }
    }
}

