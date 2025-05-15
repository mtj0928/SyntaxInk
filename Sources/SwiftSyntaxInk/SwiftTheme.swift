import Foundation
import SyntaxInk
import SwiftSyntax

public struct SwiftTheme: Theme {
    public typealias Token = TokenSyntax
    public var configuration: Configuration
    public var highlightRules: [any SwiftSyntaxHighlightRule] = []

    public init(configuration: Configuration) {
        self.configuration = configuration
        self.highlightRules = [
            KeywordHighlightRule(configuration: configuration),
            StringHighlightRule(configuration: configuration),
            NumberHighlightRule(configuration: configuration)
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
        case .backslashes(let int):
            return AttributedString()
        case .blockComment(let string):
            return AttributedString(string)
                .applying(configuration.style(for: .comments))
        case .carriageReturns(let int):
            return AttributedString()
        case .carriageReturnLineFeeds(let int):
            return AttributedString()
        case .docBlockComment(let string):
            return AttributedString(string)
                .applying(configuration.style(for: .documentationMarkup))
        case .docLineComment(let string):
            return AttributedString(string)
                .applying(configuration.style(for: .documentationMarkup))
        case .formfeeds(let int):
            return AttributedString()
        case .lineComment(let string):
            return AttributedString(string)
                .applying(configuration.style(for: .comments))
        case .newlines(let int):
            return AttributedString(String(repeating: "\n", count: int))
                .applying(configuration.style(for: .plainText))
        case .pounds(let int):
            return AttributedString()
        case .spaces(let int):
            return AttributedString(String(repeating: " ", count: int))
                .applying(configuration.style(for: .plainText))
        case .tabs(let int):
            return AttributedString(String(repeating: "\t", count: int))
                .applying(configuration.style(for: .plainText))
        case .unexpectedText(let string):
            return AttributedString(string)
                .applying(configuration.style(for: .plainText))
        case .verticalTabs(let int):
            return AttributedString()
        }
    }
}

extension SwiftTheme {
    public enum StyleKind: Sendable {
        case plainText
        case keywords
        case comments
        case documentationMarkup
        case string
        case numbers

        // TODO: Support these types
        // case documentationMarkupKeywords
        // case marks
        // case character
    }

    public struct Configuration: Sendable {
        public var baseStyle: Style
        public var converters: [StyleKind: @Sendable (inout Style) -> Void]

        func style(for kind: StyleKind) -> Style {
            var style = baseStyle
            converters[kind]?(&style)
            return style
        }
    }
}

public struct Style: Sendable {
    public var font: Font
    public var color: Color
}

public struct Color: Sendable {
    public var red: CGFloat
    public var green: CGFloat
    public var blue: CGFloat
    public var alpha: CGFloat

    public init(
        red: CGFloat,
        green: CGFloat,
        blue: CGFloat,
        alpha: CGFloat = 1.0
    ) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public struct Font: Sendable {
    public var name: String
    public var size: CGFloat
    public var weight: Weight

    public enum Weight: Sendable {
        case ultraLight
        case thin
        case light
        case regular
        case medium
        case semibold
        case bold
        case heavy
        case black
    }
}

#if canImport(AppKit)
extension AttributedString {
    public func applying(_ style: Style) -> Self {
        var copy = self
        copy.appKit.font = style.font.resolve()
        copy.appKit.foregroundColor = style.color.resolve()
        return copy
    }
}

extension Font {
    public func resolve() -> NSFont {
        let fontDescriptor = NSFontDescriptor(
            name: name,
            size: size
        ).addingAttributes([
            NSFontDescriptor.AttributeName.traits: [
                NSFontDescriptor.TraitKey.weight: weight.resolve().rawValue
            ]
        ])
        return NSFont(descriptor: fontDescriptor, size: size)!
    }
}

extension Font.Weight {
    func resolve() -> NSFont.Weight {
        switch self {
        case .ultraLight: .ultraLight
        case .thin: .thin
        case .light: .light
        case .regular: .regular
        case .medium: .medium
        case .semibold: .semibold
        case .bold: .bold
        case .heavy: .heavy
        case .black: .black
        }
    }
}

extension Color {
    func resolve() -> NSColor {
        let color = NSColor(
            calibratedRed: red / 255.0,
            green: green / 255.0,
            blue: blue / 255.0,
            alpha: alpha
        )
        return color
    }
}
#endif

extension SwiftTheme.Configuration {
    public static let defaultDark = {
        let base = Style(
            font: Font(name: "SF Mono", size: 16, weight: .regular),
            color: Color(red: 255, green: 255, blue: 255)
        )
        return defaultDark(base)
    }()

    public static func defaultDark(_ base: Style) -> SwiftTheme.Configuration {
        SwiftTheme.Configuration(baseStyle: base, converters: [
            .plainText: { style in
            },
            .keywords: { style in
                style.color = Color(red: 252, green: 95, blue: 163)
                style.font.weight = .bold
            },
            .comments: { style in
                style.color = Color(red: 108, green: 121, blue: 134)
                style.font.weight = .medium
            },
            .documentationMarkup: { style in
                style.color = Color(red: 108, green: 121, blue: 134)
                style.font = Font(name: "Helvetica", size: 16, weight: .regular)
            },
            .string: { style in
                style.color = Color(red: 252, green: 106, blue: 93)
                style.font.weight = .medium
            },
            .numbers: { style in
                style.color = Color(red: 208, green: 191, blue: 105)
                style.font.weight = .medium
            }
        ])
    }
}

// MARK: - Ruleset

public protocol SwiftSyntaxHighlightRule: Sendable {
    func decorate(_ token: TokenSyntax) -> AttributedString?
}

public struct KeywordHighlightRule: SwiftSyntaxHighlightRule {
    public var configuration: SwiftTheme.Configuration

    public init(configuration: SwiftTheme.Configuration) {
        self.configuration = configuration
    }

    public func decorate(_ token: TokenSyntax) -> AttributedString? {
        guard case .keyword = token.tokenKind else {
            return nil
        }
        return AttributedString(token.text)
            .applying(configuration.style(for: .keywords))
    }
}

public struct StringHighlightRule: SwiftSyntaxHighlightRule {
    public var configuration: SwiftTheme.Configuration
    
    public init(configuration: SwiftTheme.Configuration) {
        self.configuration = configuration
    }
    
    public func decorate(_ token: TokenSyntax) -> AttributedString? {
        switch token.tokenKind {
        case .stringSegment, .multilineStringQuote, .stringQuote:
            return AttributedString(token.text)
                .applying(configuration.style(for: .string))
        default:
            return nil
        }
    }
}

public struct NumberHighlightRule: SwiftSyntaxHighlightRule {
    public var configuration: SwiftTheme.Configuration

    public init(configuration: SwiftTheme.Configuration) {
        self.configuration = configuration
    }

    public func decorate(_ token: TokenSyntax) -> AttributedString? {
        switch token.tokenKind {
        case .integerLiteral, .floatLiteral:
            return AttributedString(token.text)
                .applying(configuration.style(for: .numbers))
        default:
            return nil
        }
    }
}
