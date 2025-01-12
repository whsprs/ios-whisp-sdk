import Foundation

public struct Command: Equatable, Hashable {
    
    // MARK: - Properties
    
    let id: String
    
    // MARK: - Private Properties
    
    private let action: () -> Void

    // MARK: - Init

    public init(
        id: String = UUID().uuidString,
        action: @escaping () -> Void
    ) {
        self.id = id
        self.action = action
    }

    func run() {
        action()
    }

    // MARK: - Equatable

    public static func == (lhs: Command, rhs: Command) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: - Static

    public static let none = Command(id: "none", action: {})
}
