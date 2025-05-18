import SyntaxInk

extension SwiftTheme {
    public static let defaultDark = {
        let base = SyntaxStyle(
            font: .system(size: 16, weight: .medium, design: .monospaced),
            color: SyntaxColor(red: 255, green: 255, blue: 255)
        )
        return defaultDark(base)
    }()

    public static func defaultDark(_ base: SyntaxStyle) -> SwiftTheme {
        SwiftTheme { kind in
            var style = base
            switch kind {
            case .plainText: break
            case .keywords:
                style.color = SyntaxColor(red: 252, green: 95, blue: 163)
                style.font.weight = .bold
            case .comments:
                style.color = SyntaxColor(red: 108, green: 121, blue: 134)
            case .documentationMarkup:
                style.color = SyntaxColor(red: 108, green: 121, blue: 134)
                style.font.name = "Helvetica"
                style.font.weight = .regular
            case .string:
                style.color = SyntaxColor(red: 252, green: 106, blue: 93)
            case .numbers:
                style.color = SyntaxColor(red: 208, green: 191, blue: 105)
            case .preprocessorStatements:
                style.color = SyntaxColor(red: 253, green: 143, blue: 63)
            case .typeDeclarations:
                style.color = SyntaxColor(red: 93, green: 216, blue: 255)
            case .otherDeclarations:
                style.color = SyntaxColor(red: 65, green: 161, blue: 192)
            case .otherClassNames:
                style.color = SyntaxColor(red: 208, green: 168, blue: 255)
            case .otherFunctionAndMethodNames:
                style.color = SyntaxColor(red: 161, green: 103, blue: 230)
            case .otherTypeNames:
                style.color = SyntaxColor(red: 208, green: 168, blue: 255)
            case .otherPropertiesAndGlobals:
                style.color = SyntaxColor(red: 161, green: 103, blue: 230)
            }
            return style
        }
    }
}
