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

public enum SyntaxFont: Sendable {
    case system(size: CGFloat, weight: Font.Weight, design: Font.Design = .monospaced)
    case custom(name: String, size: CGFloat, weight: Font.Weight)

    public init(name: String, size: CGFloat, weight: Font.Weight) {
        self = .custom(name: name, size: size, weight: weight)
    }

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
