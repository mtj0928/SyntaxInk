import Foundation
import SwiftUI

public protocol Theme: Sendable {
    associatedtype Token: Sendable
    
    func decorate(token: Token) -> AttributedString
}

