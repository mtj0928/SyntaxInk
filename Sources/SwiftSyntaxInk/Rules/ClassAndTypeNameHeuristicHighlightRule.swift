import Foundation
import SwiftSyntax

public struct ClassAndTypeNameHeuristicHighlightRule: SwiftSyntaxHighlightRule {
    public var configuration: SwiftTheme.Configuration

    public init(configuration: SwiftTheme.Configuration) {
        self.configuration = configuration
    }

    public func decorate(_ token: TokenSyntax) -> AttributedString? {
        guard case .identifier = token.tokenKind else { return nil }

        lazy var result = AttributedString(token.text)
            .applying(configuration.style(for: .otherTypeNames))

        if token.parent?.is(DeclReferenceExprSyntax.self) ?? false,
           token.text.isFirstUppercase {
            return result
        }
        return nil
    }
}

extension String {
    fileprivate var isFirstUppercase: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return CharacterSet.uppercaseLetters.contains(firstScalar)
    }
}
