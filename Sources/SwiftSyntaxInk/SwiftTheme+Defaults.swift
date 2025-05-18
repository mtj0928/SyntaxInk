import SyntaxInk

extension SwiftTheme.Configuration {
    public static let defaultDark = {
        let base = SyntaxStyle(
            font: SyntaxFont(name: "Menlo", size: 16, weight: .regular),
            color: SyntaxColor(red: 255, green: 255, blue: 255)
        )
        return defaultDark(base)
    }()

    public static func defaultDark(_ base: SyntaxStyle) -> SwiftTheme.Configuration {
        SwiftTheme.Configuration(baseStyle: base, converters: [
            .plainText: { style in
            },
            .keywords: { style in
                style.color = SyntaxColor(red: 252, green: 95, blue: 163)
                style.font.name = "Menlo Bold"
            },
            .comments: { style in
                style.color = SyntaxColor(red: 108, green: 121, blue: 134)
            },
            .documentationMarkup: { style in
                style.color = SyntaxColor(red: 108, green: 121, blue: 134)
                style.font = SyntaxFont(name: "Helvetica", size: 16, weight: .regular)
            },
            .string: { style in
                style.color = SyntaxColor(red: 252, green: 106, blue: 93)
            },
            .numbers: { style in
                style.color = SyntaxColor(red: 208, green: 191, blue: 105)
            },
            .preprocessorStatements: { style in
                style.color = SyntaxColor(red: 253, green: 143, blue: 63)
            },
            .typeDeclarations: { style in
                style.color = SyntaxColor(red: 93, green: 216, blue: 255)
            },
            .otherDeclarations: { style in
                style.color = SyntaxColor(red: 65, green: 161, blue: 192)
            },
            .otherClassNames: { style in
                style.color = SyntaxColor(red: 208, green: 168, blue: 255)
            },
            .otherTypeNames: { style in
                style.color = SyntaxColor(red: 208, green: 168, blue: 255)
            },
            .otherFunctionAndMethodNames: { style in
                style.color = SyntaxColor(red: 161, green: 103, blue: 230)
            }
        ])
    }
}
