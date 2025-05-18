#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension AttributedString {
    public func applying(_ style: Style) -> Self {
        var copy = self
#if canImport(AppKit)
        copy.appKit.font = style.font.nsFont()
        copy.appKit.foregroundColor = style.color.nsColor()
#elseif canImport(UIKit)
        copy.uiKit.font = style.font.uiFont()
        print(copy.uiKit.font)
        copy.uiKit.foregroundColor = style.color.uiColor()
#endif
        return copy
    }
}

#if canImport(AppKit)
extension Font {
    public func nsFont() -> NSFont {
        let fontDescriptor = NSFontDescriptor(
            name: name,
            size: size
        ).addingAttributes([
            NSFontDescriptor.AttributeName.traits: [
                NSFontDescriptor.TraitKey.weight: weight.nsFontWeight().rawValue
            ]
        ])
        return NSFont(descriptor: fontDescriptor, size: size)!
    }
}

extension Font.Weight {
    func nsFontWeight() -> NSFont.Weight {
        switch self {
        case .ultraLight: .ultraLight
        case .thin: .thin
        case .light: .light
        case .regular: .regular
        case .medium: .medium
        case .semibold: .semibold
        case .bold: .bold
        case .heavy: .heavy
        case .black: .black
        }
    }
}

extension Color {
    public func nsColor() -> NSColor {
        let color = NSColor(
            calibratedRed: red / 255.0,
            green: green / 255.0,
            blue: blue / 255.0,
            alpha: alpha
        )
        return color
    }
}
#elseif canImport(UIKit)
extension Font {
    public func uiFont() -> UIFont {
        let fontDescriptor = UIFontDescriptor(
            name: name,
            size: size
        ).addingAttributes([
            UIFontDescriptor.AttributeName.traits: [
                UIFontDescriptor.TraitKey.weight: weight.uiFontWeight()
            ]
        ])
        return UIFont(descriptor: fontDescriptor, size: size)
    }
}

extension Font.Weight {
    func uiFontWeight() -> UIFont.Weight {
        switch self {
        case .ultraLight: .ultraLight
        case .thin: .thin
        case .light: .light
        case .regular: .regular
        case .medium: .medium
        case .semibold: .semibold
        case .bold: .bold
        case .heavy: .heavy
        case .black: .black
        }
    }
}

extension Color {
    public func uiColor() -> UIColor {
        let color = UIColor(
            red: red / 255.0,
            green: green / 255.0,
            blue: blue / 255.0,
            alpha: alpha
        )
        return color
    }
}
#endif
