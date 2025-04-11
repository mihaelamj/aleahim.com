import Foundation
import CVBuilder
import Ignite

let myCV = CV.createForMihaela()

func generateMihaelasCVMarkdown() {
    
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

func generateMihaelasCVMarkdownInContentFolder() {
    let cv = CV.createForMihaela()
    let markdown = MarkdownCVRenderer().render(cv: cv)

    let fileURL = URL(fileURLWithPath: "Content/cv/mihaela-cv.md")

    do {
        try markdown.write(to: fileURL, atomically: true, encoding: .utf8)
        print("✅ Written to \(fileURL.path)")
    } catch {
        print("❌ Failed to write Mihaela's CV: \(error.localizedDescription)")
    }
}

