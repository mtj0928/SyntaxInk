import SyntaxInk
import SwiftUI

typealias SwiftSyntaxHighlighter = SyntaxHighlighter<SwiftGrammar, SwiftTheme>

extension SwiftSyntaxHighlighter {
    init(theme: SwiftTheme = .defaultDark) {
        self.init(grammar: SwiftGrammar(), theme: theme)
    }
}

extension SwiftUI.Color {
    public static let xcodeBackgroundDefaultDarkColor = Color(
        red: 41 / 255.0,
        green: 42 / 255.0,
        blue: 47 / 255.0
    )
}
