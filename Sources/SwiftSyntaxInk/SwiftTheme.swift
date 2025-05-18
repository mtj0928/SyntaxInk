import Foundation
import SyntaxInk
import SwiftSyntax

public struct SwiftTheme: Theme {
    public typealias Token = TokenSyntax
    public var configuration: Configuration
    public var highlightRules: [any SwiftSyntaxHighlightRule] = []

    public init(_ styleResolver: @escaping @Sendable (StyleKind) -> SyntaxStyle) {
        self.configuration = Configuration(styleResolver: styleResolver)
        self.highlightRules = [
            KeywordHighlightRule(configuration: configuration),
            AttributeHeuristicHighlightRule(configuration: configuration),
            StringHighlightRule(configuration: configuration),
            NumberHighlightRule(configuration: configuration),
            PreprocessorHighlightRule(configuration: configuration),
            TypeDeclarationHighlightRule(configuration: configuration),
            OtherDeclarationHighlightRule(configuration: configuration),
            ClassAndTypeNameHighlightRule(configuration: configuration),
            ClassAndTypeNameHeuristicHighlightRule(configuration: configuration),
            FunctionAndPropertyHighlightRule(configuration: configuration),
        ]
    }

    public func decorate(token: TokenSyntax) -> AttributedString {
        let results = highlightRules.lazy
            .compactMap { rule in rule.decorate(token) }
            .first ?? AttributedString(token.text).applying(configuration.style(for: .plainText))

        return applyTrivia(to: results, for: token)
    }


    private func applyTrivia(to attributedString: AttributedString, for token: TokenSyntax) -> AttributedString {
        var results = attributedString
        for piece in token.leadingTrivia.pieces.reversed() {
            results = triviaAttributedString(piece) + results
        }
        for piece in token.trailingTrivia.pieces {
            results = results + triviaAttributedString(piece)
        }
        return results
    }

    private func triviaAttributedString(_ trivia: TriviaPiece) -> AttributedString {
        switch trivia {
        case .backslashes(let count):
            return AttributedString(String(repeating: #"\"#, count: count))
                .applying(configuration.style(for: .plainText))
        case .blockComment(let string):
            return AttributedString(string)
                .applying(configuration.style(for: .comments))
        case .carriageReturns(let count):
            return AttributedString(String(repeating: "\r", count: count))
                .applying(configuration.style(for: .plainText))
        case .carriageReturnLineFeeds(let count):
            return AttributedString(String(repeating: "\r\n", count: count))
                .applying(configuration.style(for: .plainText))
        case .docBlockComment(let string):
            return AttributedString(string)
                .applying(configuration.style(for: .documentationMarkup))
        case .docLineComment(let string):
            return AttributedString(string)
                .applying(configuration.style(for: .documentationMarkup))
        case .formfeeds(let count):
            return AttributedString(String(repeating: "\u{c}", count: count))
                .applying(configuration.style(for: .plainText))
        case .lineComment(let string):
            return AttributedString(string)
                .applying(configuration.style(for: .comments))
        case .newlines(let count):
            return AttributedString(String(repeating: "\n", count: count))
                .applying(configuration.style(for: .plainText))
        case .pounds(let count):
            return AttributedString(String(repeating: "#", count: count))
        case .spaces(let count):
            return AttributedString(String(repeating: " ", count: count))
                .applying(configuration.style(for: .plainText))
        case .tabs(let count):
            return AttributedString(String(repeating: "\t", count: count))
                .applying(configuration.style(for: .plainText))
        case .unexpectedText(let string):
            return AttributedString(string)
                .applying(configuration.style(for: .plainText))
        case .verticalTabs(let count):
            return AttributedString(String(repeating: "\u{b}", count: count))
                .applying(configuration.style(for: .plainText))
        }
    }
}

extension SwiftTheme {
    // Follow Xcode's theme
    public enum StyleKind: Sendable {
        case plainText
        case keywords
        case comments
        case documentationMarkup
        case string
        case numbers
        case preprocessorStatements
        case typeDeclarations
        case otherDeclarations
        case otherClassNames
        case otherFunctionAndMethodNames
        case otherTypeNames
        case otherPropertiesAndGlobals

        // TODO: Support these types
        // case documentationMarkupKeywords
        // case marks
        // case character
        // case regexLiterals
        // case regexLiteralNumbers
        // case regexLiteralCaptureNames
        // case regexLiteralCharacterClassNames
        // case regexLiteralOperatons
        // case urls
        // case attributes
        // case projectClassNames
        // case projectFunctionAndMethodNames
        // case projectConstants
        // case projectTypeNames
        // case projectPropertiesAndGlobals
        // case projectPreprocessorMacros
        // case otherConstants
        // case otherPreprocessorMacros
        // case heading
    }

    public struct Configuration: Sendable {
        public var styleResolver: @Sendable (StyleKind) -> SyntaxStyle

        func style(for kind: StyleKind) -> SyntaxStyle {
            styleResolver(kind)
        }
    }
}
