import SwiftUI

extension AttributedString {
    public func applying(_ style: SyntaxStyle) -> Self {
        var copy = self
        copy.swiftUI.font = style.font.resolve()
        copy.swiftUI.foregroundColor = style.color.resolve()
        return copy
    }
}

extension SyntaxFont {
    fileprivate func resolve() -> Font {
        switch self {
        case .system(let size, let weight, let design):
            return .system(size: size, weight: weight, design: design)
        case .custom(let name, let size, let weight):
            return .custom(name, size: size)
                .weight(weight)
        }
    }
}

extension SyntaxColor {
    fileprivate func resolve() -> Color {
        Color(cgColor: CGColor(
            red: red / 255.0,
            green: green / 255.0,
            blue: blue / 255.0,
            alpha: alpha
        ))
    }
}
