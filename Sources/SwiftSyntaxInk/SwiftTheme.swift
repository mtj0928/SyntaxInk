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
        public var baseStyle: Style
        public var converters: [StyleKind: @Sendable (inout Style) -> Void]

        func style(for kind: StyleKind) -> Style {
            var style = baseStyle
            converters[kind]?(&style)
            return style
        }
    }
}

// MARK: - Ruleset

public protocol SwiftSyntaxHighlightRule: Sendable {
    func decorate(_ token: TokenSyntax) -> AttributedString?
}

enum WalkParentAction<T> {
    case found(T)
    case notFound
    case moveToParent
}

extension SwiftSyntaxHighlightRule {
    func walkParent<T>(of node: Syntax, handler: (Syntax) -> WalkParentAction<T>) -> T? {
        var currentNode: Syntax? = node
        while let node = currentNode {
            let result = handler(node)
            switch result {
            case .found(let value): return value
            case .notFound: return nil
            case .moveToParent: currentNode = node.parent
            }
        }
        return nil
    }
}

public struct KeywordHighlightRule: SwiftSyntaxHighlightRule {
    public var configuration: SwiftTheme.Configuration
    let predefinedMacroKeywords = [
        "file", "filePath", "fileID", "function", "line", "column", "dsohandle", "isolation"
    ]

    public init(configuration: SwiftTheme.Configuration) {
        self.configuration = configuration
    }

    public func decorate(_ token: TokenSyntax) -> AttributedString? {
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

public struct TypeDeclarationHighlightRule: SwiftSyntaxHighlightRule {
    public var configuration: SwiftTheme.Configuration
    
    public init(configuration: SwiftTheme.Configuration) {
        self.configuration = configuration
    }
    
    public func decorate(_ token: TokenSyntax) -> AttributedString? {
        guard case .identifier = token.tokenKind else {
            return nil
        }
        return walkParent(of: Syntax(token)) { node in
            func result() -> AttributedString {
                AttributedString(token.text)
                    .applying(configuration.style(for: .typeDeclarations))
            }

            // class
            if let typeDeclarationSyntax = node.as(ClassDeclSyntax.self) {
                if typeDeclarationSyntax.name.id == token.id {
                    return .found(result())
                }
                return .notFound
            }

            // struct
            if let typeDeclarationSyntax = node.as(StructDeclSyntax.self) {
                if typeDeclarationSyntax.name.id == token.id {
                    return .found(result())
                }
                return .notFound
            }

            // protocol
            if let typeDeclarationSyntax = node.as(ProtocolDeclSyntax.self) {
                if typeDeclarationSyntax.name.id == token.id {
                    return .found(result())
                }
                return .notFound
            }

            // enum
            if let typeDeclarationSyntax = node.as(EnumDeclSyntax.self) {
                if typeDeclarationSyntax.name.id == token.id {
                    return .found(result())
                }
                return .notFound
            }

            // actor
            if let typeDeclarationSyntax = node.as(ActorDeclSyntax.self) {
                if typeDeclarationSyntax.name.id == token.id {
                    return .found(result())
                }
                return .notFound
            }

            if let extensionDeclarationSyntax = node.parent?.as(ExtensionDeclSyntax.self) {
                if extensionDeclarationSyntax.extendedType.id == node.id  {
                    return .found(result())
                }
                return .notFound
            }

            return .moveToParent
        }
    }
}

public struct OtherDeclarationHighlightRule: SwiftSyntaxHighlightRule {
    public var configuration: SwiftTheme.Configuration

    public init(configuration: SwiftTheme.Configuration) {
        self.configuration = configuration
    }

    public func decorate(_ token: TokenSyntax) -> AttributedString? {
        guard case .identifier = token.tokenKind else {
            return nil
        }

        return walkParent(of: Syntax(token)) { node in
            func result() -> AttributedString {
                AttributedString(token.text)
                    .applying(configuration.style(for: .otherDeclarations))
            }

            // property declaration
            if let patternBinding = node.parent?.as(PatternBindingSyntax.self),
               patternBinding.pattern.id == node.id {
                if let patternBindingList = patternBinding.parent?.as(PatternBindingListSyntax.self),
                   let variableDeclaration = patternBindingList.parent?.as(VariableDeclSyntax.self),
                   variableDeclaration.parent?.is(MemberBlockItemSyntax.self) ?? false {
                    return .found(result())
                }
                return .notFound
            }

            // function declaration
            if let functionDeclaration = node.as(FunctionDeclSyntax.self) {
                if functionDeclaration.name.id == token.id {
                    return .found(result())
                }
                return .notFound
            }

            // argument label of a function
            if let functionParameter = node.as(FunctionParameterSyntax.self) {
                if functionParameter.firstName.id == token.id {
                    return .found(result())
                }
                return .notFound
            }

            // typealias declaration
            if let typeAlias = node.as(TypeAliasDeclSyntax.self) {
                if typeAlias.name.id == token.id {
                    return .found(result())
                }
                return .notFound
            }

            if let associatedType = node.as(AssociatedTypeDeclSyntax.self) {
                if associatedType.name.id == token.id {
                    return .found(result())
                }
                return .notFound
            }
            return .moveToParent
        }
    }
}

public struct AttributeHeuristicHighlightRule: SwiftSyntaxHighlightRule {
    public var configuration: SwiftTheme.Configuration
    var predefinedAttributes: [String] {
        // Follow the official document
        // https://docs.swift.org/swift-book/documentation/the-swift-programming-language/attributes/
        [
            "available",
            "backDeployed",
            "discardableResult",
            "dynamicCallable",
            "dynamicMemberLookup",
            "frozen",
            "GKInspectable",
            "inlinable",
            "main",
            "nonobjc",
            "NSApplicationMain",
            "NSCopying",
            "NSManaged",
            "objc",
            "objcMembers",
            "preconcurrency",
            "propertyWrapper",
            "resultBuilder",
            "requires_stored_property_inits",
            "testable",
            "UIApplicationMain",
            "unchecked",
            "usableFromInline",
            "warn_unqualified_access",
            "IBAction",
            "IBSegueAction",
            "IBOutlet",
            "IBDesignable",
            "IBInspectable",
            "autoclosure",
            "convention",
            "escaping",
            "Sendable",
            "unknown"
        ]
    }
    public init(configuration: SwiftTheme.Configuration) {
        self.configuration = configuration
    }
    
    public func decorate(_ token: TokenSyntax) -> AttributedString? {
        let attributeName: String
        if let identifierTypeSyntax = token.parent?.as(IdentifierTypeSyntax.self),
           identifierTypeSyntax.parent?.is(AttributeSyntax.self) ?? false {
            attributeName = token.text
        } else if token.tokenKind == .atSign,
                  let attribute = token.parent?.as(AttributeSyntax.self),
                  let identifierTypeSyntax = attribute.attributeName.as(IdentifierTypeSyntax.self) {
            attributeName = identifierTypeSyntax.name.text
        } else {
            return nil
        }


        let attributedString = AttributedString(token.text)

        return predefinedAttributes.contains(attributeName)
        ? attributedString.applying(configuration.style(for: .keywords))
        : attributedString.applying(configuration.style(for: .otherTypeNames))
    }
}

public struct ClassAndTypeNameHighlightRule: SwiftSyntaxHighlightRule {
    public var configuration: SwiftTheme.Configuration
    
    public init(configuration: SwiftTheme.Configuration) {
        self.configuration = configuration
    }
    
    public func decorate(_ token: TokenSyntax) -> AttributedString? {
        guard token.parent?.is(IdentifierTypeSyntax.self) ?? false else { return nil }
        return AttributedString(token.text)
            .applying(configuration.style(for: .otherTypeNames))
    }
}

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

public struct FunctionAndPropertyHighlightRule: SwiftSyntaxHighlightRule {
    public var configuration: SwiftTheme.Configuration
    
    public init(configuration: SwiftTheme.Configuration) {
        self.configuration = configuration
    }
    
    public func decorate(_ token: TokenSyntax) -> AttributedString? {
        // A pattern of simple function call
        if case .identifier = token.tokenKind,
           let declReferenceExprSyntax = token.parent?.as(DeclReferenceExprSyntax.self),
           declReferenceExprSyntax.baseName == token,
           let functionCallExprSyntax = declReferenceExprSyntax.parent?.as(FunctionCallExprSyntax.self),
           functionCallExprSyntax.calledExpression.id == declReferenceExprSyntax.id {
            return AttributedString(token.text).applying(configuration.style(for: .otherFunctionAndMethodNames))
        }

        // A pattern of member access like foo.doSomething
        if case .identifier = token.tokenKind,
           let declReferenceExprSyntax = token.parent?.as(DeclReferenceExprSyntax.self),
           declReferenceExprSyntax.baseName == token,
           let memberAccessExprSyntax = declReferenceExprSyntax.parent?.as(MemberAccessExprSyntax.self),
           memberAccessExprSyntax.declName.id == declReferenceExprSyntax.id {
            return AttributedString(token.text).applying(configuration.style(for: .otherFunctionAndMethodNames))
        }

        // macro pattern
        if token.parent?.is(MacroExpansionExprSyntax.self) ?? false {
            switch token.tokenKind {
            case .identifier, .pound:
                return AttributedString(token.text).applying(configuration.style(for: .otherFunctionAndMethodNames))
            default: break
            }
        }

        return nil
    }
}

extension String {
    var isFirstUppercase: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return CharacterSet.uppercaseLetters.contains(firstScalar)
    }
}
