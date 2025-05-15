#if DEBUG
import SwiftUI
import SyntaxInk

let code = """
import Observation

@Observable 
@MainActor 
final class Person: Sendable { 
    var name: String 
    var age: Int = 1234.0

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    // MARK: - Foo

#if DEBUG
    /// AAA
    /// ```swift
    /// let message = "helo"
    /// ```
    func greets(_ actor: isolated (any Actor)? = #isolation) {
        // do something
        print("Hello")
    }
#endif

}

let person = Person()
print("Name: \\(person.name)", 'a')
\"""
hello
\"""
"""

#Preview {
    let syntaxHighlighter = SyntaxHighlighter(
        grammar: SwiftGrammar(),
        theme: SwiftTheme(configuration: .defaultDark)
    )
    let attributedString = syntaxHighlighter.highlight(code)
    Text(attributedString)
        .padding()
        .frame(width: 700,  height: 700, alignment: .topLeading)
        .background(SwiftUI.Color(red: 41 / 255.0, green: 42 / 255.0, blue: 47 / 255.0))
}
#endif
