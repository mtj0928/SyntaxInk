import Foundation
import SwiftSyntax

public struct ClassAndTypeNameHighlightRule: SwiftSyntaxHighlightRule {
    public var configuration: SwiftTheme.Configuration
    
    public init(configuration: SwiftTheme.Configuration) {
        self.configuration = configuration
    }
    
    public func attributes(for token: TokenSyntax) -> AttributedString? {
        guard token.parent?.is(IdentifierTypeSyntax.self) ?? false else { return nil }
        return AttributedString(token.text)
            .applying(configuration.style(for: .otherTypeNames))
    }
}
