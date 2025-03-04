//
//  ReadingTime.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Foundation
import Publish

extension Plugin {
    
    /// Plugin that calculates the average reading time of each `Item`.
    /// Use `Item.readingTime` to access the data.
    /// - Parameter wordsPerMinute: Average reading speed (words per minute) used to calculate the reading time.
    public static func readingTime(wordsPerMinute: Int = 200) -> Self {
        Plugin(name: "Reading time") { context in
            context.mutateAllSections { section in
                section.mutateItems { item in
                    data[item.path.string] = estimateTime(for: item.content.body.html, wordsPerMinute: wordsPerMinute)
                }
            }
        }
    }
}

public extension Item {
    var readingTime: ReadingTimeMetadata {
        guard let metadata = data[path.string] else {
            output(
                #"Item "\#(self.title)" doesn't have ReadingTimeMetadata. Check that the ReadingTime plugin is installed after the creation of this item."#,
                .error
            )
            return ReadingTimeMetadata(
                minutes: 0,
                words: 0,
                timeMinutes: 0
            )
        }
        return metadata
    }
}

private var data = [AnyHashable: ReadingTimeMetadata]()

func estimateTime(for string: String, wordsPerMinute: Int) -> ReadingTimeMetadata {
    let words = countWords(string)
    let minutes = Double(words) / Double(wordsPerMinute)
    return ReadingTimeMetadata(
        minutes: Int(minutes.rounded()),
        words: words,
        timeMinutes: minutes
    )
}

private func countWords(_ string: String) -> Int {
    // Ideally we would be able to get a plain string (even if it's the original markdown) from Plot
    let plain = string.replacingOccurrences(of: "<[^>]+>", with: " ", options: .regularExpression, range: nil)
    let separators = CharacterSet
        .whitespacesAndNewlines
        .union(.punctuationCharacters)
    let words = plain.components(separatedBy: separators)
        .filter({ !$0.isEmpty })
    return words.count
}

var output: (String, OutputKind) -> Void = { (string, kind) in
    var string = string + "\n"

    if let emoji = kind.emoji {
        string = "\(emoji) \(string)"
    }

    fputs(string, kind.target)
}

enum OutputKind {
    case info
    case warning
    case error
    case success
}
   
private extension OutputKind {
    var emoji: Character? {
        switch self {
        case .info:
            return nil
        case .warning:
            return "⚠️"
        case .error:
            return "❌"
        case .success:
            return "✅"
        }
    }

    var target: UnsafeMutablePointer<FILE> {
        switch self {
        case .info, .warning, .success:
            return stdout
        case .error:
            return stdout
        }
    }
}
