#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension AttributedString {
    public func applying(_ style: SyntaxStyle) -> Self {
        var copy = self
#if canImport(AppKit)
        copy.appKit.font = style.font.nsFont()
        copy.appKit.foregroundColor = style.color.nsColor()
#elseif canImport(UIKit)
        copy.uiKit.font = style.font.uiFont()
        copy.uiKit.foregroundColor = style.color.uiColor()
#endif
        return copy
    }
}

extension SyntaxFont {
#if canImport(AppKit)
    public func nsFont() -> NSFont {
        let fontDescriptor = NSFontDescriptor(
            name: name,
            size: size
        ).addingAttributes([
            NSFontDescriptor.AttributeName.traits: [
                NSFontDescriptor.TraitKey.weight: weight.platformWeight().rawValue
            ]
        ])
        return NSFont(descriptor: fontDescriptor, size: size)!
    }
#elseif canImport(UIKit)
    public func uiFont() -> UIFont {
        let fontDescriptor = UIFontDescriptor(
            name: name,
            size: size
        ).addingAttributes([
            UIFontDescriptor.AttributeName.traits: [
                UIFontDescriptor.TraitKey.weight: weight.platformWeight()
            ]
        ])
        return UIFont(descriptor: fontDescriptor, size: size)
    }
#endif
}

extension SyntaxFont.SyntaxWeight {
#if canImport(UIKit)
    typealias PlatformWeight = UIFont.Weight
#elseif canImport(AppKit)
    typealias PlatformWeight = NSFont.Weight
#endif

    func platformWeight() -> PlatformWeight {
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

extension SyntaxColor {
#if canImport(AppKit)
    public func nsColor() -> NSColor {
        let color = NSColor(
            calibratedRed: red / 255.0,
            green: green / 255.0,
            blue: blue / 255.0,
            alpha: alpha
        )
        return color
    }
#elseif canImport(UIKit)
    public func uiColor() -> UIColor {
        UIColor(cgColor:CGColor(
            red: red / 255.0,
            green: green / 255.0,
            blue: blue / 255.0,
            alpha: alpha
        ))
    }
#endif
}
