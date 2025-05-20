import Foundation
import SwiftSyntax

public struct KeywordHighlightRule: SwiftSyntaxHighlightRule {
    public var configuration: SwiftTheme.Configuration
    private let predefinedMacroKeywords = [
        "file",
        "filePath",
        "fileID",
        "function",
        "line",
        "column",
        "dsohandle",
        "isolation"
    ]

    public init(configuration: SwiftTheme.Configuration) {
        self.configuration = configuration
    }

    public func attributes(for token: TokenSyntax) -> AttributedString? {
        lazy var result = AttributedString(token.text)
            .applying(configuration.style(for: .keywords))

        if case .keyword = token.tokenKind {
            return result
        } else if let macro = token.parent?.as(MacroExpansionExprSyntax.self),
                  predefinedMacroKeywords.contains(macro.macroName.text) {
            return result
        } else {
            return nil
        }
    }
}
