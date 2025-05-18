#if DEBUG
import SwiftUI
import SyntaxInk

typealias SwiftSyntaxHighlighter = SyntaxHighlighter<SwiftGrammar, SwiftTheme>

extension SwiftSyntaxHighlighter {
    init() {
        self.init(grammar: SwiftGrammar(), theme: .defaultDark)
    }
}

extension SwiftUI.Color {
    static let xcodeBackgroundColor = SwiftUI.Color(red: 41 / 255.0, green: 42 / 255.0, blue: 47 / 255.0)
}

struct Playground: View {
    var code: String

    var body: some View {
        let syntaxHighlighter = SwiftSyntaxHighlighter()
        let attributedString = syntaxHighlighter.highlight(code)
        ScrollView {
            Text(attributedString)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.xcodeBackgroundColor)
#if os(visionOS)
        .glassBackgroundEffect()
#endif
    }
}

let sourceCode = """
import Observation

struct Foo {}
enum Bar {}
actor Baz {}

@Observable
@MainActor
final class Person<T: Hashable>: Sendable, Hashable {
    var age: Int = 1234.0

    /// Creates an instance
    init(age: Int) { 
        self.age = age 
    }

#if os(iOS)
    func aaa(_ actor: isolated (any Actor)? = #isolation) {
        // do something
    }
#else 
    func aaa() async throws(FooError) {
        let foo = Foo()
        foo.doSomething(foo.number, aaa: T.aaa())
    }
#endif
}

let person = Person()
print("Name: \\(person.name)")
#expect(true)
"""

#Preview {
    let syntaxHighlighter = SwiftSyntaxHighlighter()
    let attributedString = syntaxHighlighter.highlight(sourceCode)
    ScrollView {
        Text(attributedString)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(Color.xcodeBackgroundColor)
}


let code2 = """
class Foo { 
    typealias AAA = String
}

protocol Foo { 
    associatedtype AAAA
}

extension Foo.AAA {
    var number: Int {
        get { 10 }
        nonmutating set { }
    }
}
"""

#Preview {
    Playground(code: code2)
}

let code3 = """
protocol TP {
    static func number() -> Int
}

struct BBB {
    static let shared = BBB()
}

struct AAA<T: TP> {
    private func aaa(_ handler: @escaping @Sendable () -> Void) {
    }

    func doo(_ actor: isolated (any Actor)? = #isolation) {
        let ff = AAA()
        let _ = BBB.shared
        let number = T.number()
        if 1 == 2 {}
        #expect(1 == 1)
    }

    subscript() {}
}
"""

#Preview {
    Playground(code: code3)
}

#endif
