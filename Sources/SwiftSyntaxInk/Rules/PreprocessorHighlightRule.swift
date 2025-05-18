import Foundation
import SwiftSyntax

public struct PreprocessorHighlightRule: SwiftSyntaxHighlightRule {
    public var configuration: SwiftTheme.Configuration

    public init(configuration: SwiftTheme.Configuration) {
        self.configuration = configuration
    }

    public func decorate(_ token: TokenSyntax) -> AttributedString? {
        if [TokenKind.poundIf, .poundEndif, .poundElse, .poundElseif].contains(token.tokenKind) {
            return AttributedString(token.text)
                .applying(configuration.style(for: .preprocessorStatements))
        }

        return walkParent(of: Syntax(token)) { node in
            guard let ifConfigClauseSyntax = node.parent?.as(IfConfigClauseSyntax.self) else {
                return .moveToParent
            }
            if ifConfigClauseSyntax.condition?.id == node.id {
                let result = AttributedString(token.text)
                    .applying(configuration.style(for: .preprocessorStatements))
                return .found(result)
            }
            return .notFound
        }
    }
}
