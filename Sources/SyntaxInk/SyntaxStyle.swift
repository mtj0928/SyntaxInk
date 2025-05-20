import Foundation
import SwiftUI

/// A style of the syntax.
/// This struct has font and color information for a token.
public struct SyntaxStyle: Sendable {
    /// A font for a token.
    public var font: SyntaxFont

    /// A color for a cor a token.
    public var color: SyntaxColor

    public init(font: SyntaxFont, color: SyntaxColor) {
        self.font = font
        self.color = color
    }
}

/// A color for a cor a token.
public struct SyntaxColor: Sendable {
    public var red: CGFloat
    public var green: CGFloat
    public var blue: CGFloat
    public var alpha: CGFloat

    public init(
        red: CGFloat,
        green: CGFloat,
        blue: CGFloat,
        alpha: CGFloat = 1.0
    ) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}

/// A font information for a syntax.
public enum SyntaxFont: Sendable {
    /// A system font.
    case system(size: CGFloat, weight: Font.Weight, design: Font.Design = .monospaced)
    /// A custom font.
    case custom(name: String, size: CGFloat, weight: Font.Weight)

    public init(name: String, size: CGFloat, weight: Font.Weight) {
        self = .custom(name: name, size: size, weight: weight)
    }

    /// A name of a custom font.
    /// `nil` is returns when this font is a system font.
    /// And, when `nil` is set, the font will be a monospaced system font.
    public var name: String? {
        get {
            switch self {
            case .system: nil
            case .custom(let name, _, _ ): name
            }
        }
        set {
            self = if let newValue {
                .custom(name: newValue, size: size, weight: weight)
            } else {
                .system(size: size, weight: weight, design: .monospaced)
            }
        }
    }

    /// A size of this font.
    public var size: CGFloat {
        get {
            switch self {
            case .system(let size, _, _): size
            case .custom(_, let size, _): size
            }
        }
        set {
            switch self {
            case .system(_, let weight, let design):
                self = .system(size: newValue, weight: weight, design: design)
            case .custom(let name, let size, let weight):
                self = .custom(name: name, size: size, weight: weight)
            }
        }
    }

    /// A weight for this font.
    public var weight: Font.Weight {
        get {
            switch self {
            case .system(_, let weight, _): weight
            case .custom(_, _, let weight): weight
            }
        }
        set {
            switch self {
            case .system(let size, _, let design):
                self = .system(size: size, weight: newValue, design: design)
            case .custom(let name, let size, _):
                self = .custom(name: name, size: size, weight: newValue)
            }
        }
    }
}
