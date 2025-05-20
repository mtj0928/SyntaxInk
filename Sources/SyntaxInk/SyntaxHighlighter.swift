import Foundation

/// A syntax highligher.
public struct SyntaxHighlighter<
    Grammar: SyntaxInk.Grammar,
    Theme: SyntaxInk.Theme
>: Sendable where Theme.Token == Grammar.Token {
    private let grammar: Grammar
    private let theme: Theme

    public init(grammar: Grammar, theme: Theme) {
        self.grammar = grammar
        self.theme = theme
    }

    /// Highlights the given code and returns `AttributedString`.
    public func highlight(_ code: String) -> AttributedString {
        let tokens = grammar.tokenize(code)
        let attributes = tokens.map { theme.attributes(for: $0) }
        return attributes.reduce(AttributedString()) { result, attribute in
            result + attribute
        }
    }
}
