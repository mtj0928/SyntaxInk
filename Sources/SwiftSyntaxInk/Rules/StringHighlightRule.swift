import Foundation
import SwiftSyntax

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
