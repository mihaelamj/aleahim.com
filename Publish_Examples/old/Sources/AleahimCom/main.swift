import Foundation
import Publish
import Plot
import SplashPublishPlugin

// This will generate your website using the built-in Foundation theme:
try AleahimCom().publish(withTheme: .aleahimTheme, //.demoTheme, // , // .foundation, .demoTheme,
                         //additionalSteps: [.deploy(using: .gitHub(""))],
                         plugins: [.splash(withClassPrefix: "")]
)

