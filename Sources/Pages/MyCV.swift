import Foundation
import CVBuilder
import Ignite

let myCV = CV.createForMihaela()

func testCreatingMihaelasCV() {
    
    let mmjCV = CV.createForMihaela()
    print("Created")
    
    let stringRenderer = StringCVRenderer()
    let stringOutput = stringRenderer.render(cv: mmjCV)
    print("Rendered String Output:\n\n\(stringOutput)")

    let consoleRenderer = ConsoleCVRenderer()
    consoleRenderer.printToConsole(cv: mmjCV)

    if let markdownFile = CV.convertTMarkdownAndSave(mmjCV) {
        print("Markdown saved to: \(markdownFile)")
    }
}

