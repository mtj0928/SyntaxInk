# SyntaxInk

A syntax highlighter for Swift.

The package has capability to highlight various languages, but only Swift is supported for now.

## Usage
You can get `AttributedString` from `String` easily.
```swift
let sourceCode = """
let person = Person(name: "matsuji")
try! await person.say("Hi, SyntaxInk can highlight Swift code!")
"""

#Preview {
    let syntaxHighlighter = SwiftSyntaxHighlighter(theme: .default)
    let attributedString = syntaxHighlighter.highlight(sourceCode)
    Text(attributedString)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.xcodeBackgroundDefaultColor)
}
```

This is the results of the preview.

<img width="734" alt="screenshot" src="https://github.com/user-attachments/assets/d51f8e9c-acff-4e44-887e-dcf997beeae8" />

You can specify `dafaultDark` as a theme and `xcodeBackgroundDefaultDarkColor` as a background.
```swift
#Preview {
    let syntaxHighlighter = SwiftSyntaxHighlighter(theme: .defaultDark) // Change the theme
    // ...
    Text(attributedString)
        // ...
        .background(Color.xcodeBackgroundDefaultDarkColor) // Change the background
}
```

<img width="734" alt="screenshot_dark" src="https://github.com/user-attachments/assets/a1c015bd-fc1f-49e9-899d-d2bcf27c5dc9" />


## Install
```swift
let package = Package(
    // ...
    dependencies: [
        .package(url: "https://github.com/mtj0928/SyntaxInk.git", from: "0.0.1"),
    ],
    targets: [
        .target(name: "YOU_TARGET", dependencies: [
            .product(name: "SwiftSyntaxInk", package: "SyntaxInk"),
            .product(name: "SyntaxInk", package: "SyntaxInk")
        ])
    ]
)
```

## Support Environment
- Swift 6.0+
- macOS 12+, iOS 15+, tvOS 15+, watchOS 8+, visionOS 1+
