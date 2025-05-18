public protocol Grammar: Sendable {
    associatedtype Token: Sendable

    func tokenize(_ code: String) -> [Token]
}
