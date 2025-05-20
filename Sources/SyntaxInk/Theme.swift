import Foundation

/// A theme of a syntax hight.
public protocol Theme: Sendable {

    /// A token for this theme.
    associatedtype Token: Sendable

    /// Gets `AttributedString` for the given token.
    func attributes(for token: Token) -> AttributedString
}
