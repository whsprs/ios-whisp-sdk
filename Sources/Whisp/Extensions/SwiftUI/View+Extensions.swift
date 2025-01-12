import SwiftUI

extension View where Self: Equatable {
    public func equatable() -> EquatableView<Self> {
        return EquatableView(content: self)
    }
}
