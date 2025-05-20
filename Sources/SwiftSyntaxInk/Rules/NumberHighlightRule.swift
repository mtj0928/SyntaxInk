import Foundation
import SwiftSyntax

public struct NumberHighlightRule: SwiftSyntaxHighlightRule {
    public var configuration: SwiftTheme.Configuration

    public init(configuration: SwiftTheme.Configuration) {
        self.configuration = configuration
    }

    public func attributes(for token: TokenSyntax) -> AttributedString? {
        switch token.tokenKind {
        case .integerLiteral, .floatLiteral:
            return AttributedString(token.text)
                .applying(configuration.style(for: .numbers))
        default:
            return nil
        }
    }
}
