import SyntaxInk
import SwiftUI

typealias SwiftSyntaxHighlighter = SyntaxHighlighter<SwiftGrammar, SwiftTheme>

extension SwiftSyntaxHighlighter {
    init(theme: SwiftTheme = .default) {
        self.init(grammar: SwiftGrammar(), theme: theme)
    }
}

extension SwiftUI.Color {
    public static let xcodeBackgroundDefaultColor = Color(red: 1, green: 1, blue: 1)

    public static let xcodeBackgroundDefaultDarkColor = Color(
        red: 41 / 255.0,
        green: 42 / 255.0,
        blue: 47 / 255.0
    )
}
