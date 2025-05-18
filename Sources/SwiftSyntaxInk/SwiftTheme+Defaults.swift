import SyntaxInk

extension SwiftTheme.Configuration {
    public static let defaultDark = {
        let base = Style(
            font: Font(name: "Menlo", size: 16, weight: .regular),
            color: Color(red: 255, green: 255, blue: 255)
        )
        return defaultDark(base)
    }()

    public static func defaultDark(_ base: Style) -> SwiftTheme.Configuration {
        SwiftTheme.Configuration(baseStyle: base, converters: [
            .plainText: { style in
            },
            .keywords: { style in
                style.color = Color(red: 252, green: 95, blue: 163)
                style.font.weight = .bold
            },
            .comments: { style in
                style.color = Color(red: 108, green: 121, blue: 134)
                style.font.weight = .medium
            },
            .documentationMarkup: { style in
                style.color = Color(red: 108, green: 121, blue: 134)
                style.font = Font(name: "Helvetica", size: 16, weight: .regular)
            },
            .string: { style in
                style.color = Color(red: 252, green: 106, blue: 93)
                style.font.weight = .medium
            },
            .numbers: { style in
                style.color = Color(red: 208, green: 191, blue: 105)
                style.font.weight = .medium
            },
            .preprocessorStatements: { style in
                style.color = Color(red: 253, green: 143, blue: 63)
                style.font.weight = .medium
            },
            .typeDeclarations: { style in
                style.color = Color(red: 93, green: 216, blue: 255)
                style.font.weight = .medium
            },
            .otherDeclarations: { style in
                style.color = Color(red: 65, green: 161, blue: 192)
                style.font.weight = .medium
            },
            .otherClassNames: { style in
                style.color = Color(red: 208, green: 168, blue: 255)
                style.font.weight = .medium
            },
            .otherTypeNames: { style in
                style.color = Color(red: 208, green: 168, blue: 255)
                style.font.weight = .medium
            },
            .otherFunctionAndMethodNames: { style in
                style.color = Color(red: 161, green: 103, blue: 230)
                style.font.weight = .medium
            }
        ])
    }
}
