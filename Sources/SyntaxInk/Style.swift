import Foundation

public struct Style: Sendable {
    public var font: Font
    public var color: Color

    public init(font: Font, color: Color) {
        self.font = font
        self.color = color
    }
}

public struct Color: Sendable {
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

public struct Font: Sendable {
    public var name: String
    public var size: CGFloat
    public var weight: Weight

    public init(name: String, size: CGFloat, weight: Weight) {
        self.name = name
        self.size = size
        self.weight = weight
    }
}

extension Font {
    public enum Weight: Sendable {
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
