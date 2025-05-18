import Foundation
import SwiftUI

public struct SyntaxStyle: Sendable {
    public var font: SyntaxFont
    public var color: SyntaxColor

    public init(font: SyntaxFont, color: SyntaxColor) {
        self.font = font
        self.color = color
    }
}

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

public struct SyntaxFont: Sendable {
    public var name: String
    public var size: CGFloat
    public var weight: SyntaxWeight

    public init(name: String, size: CGFloat, weight: SyntaxWeight) {
        self.name = name
        self.size = size
        self.weight = weight
    }
}

extension SyntaxFont {
    public enum SyntaxWeight: Sendable {
        case ultraLight
        case thin
        case light
        case regular
        case medium
        case semibold
        case bold
        case heavy
        case black
    }
}
