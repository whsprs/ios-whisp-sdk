public struct RequestPriority: Comparable, Sendable {
    let value: Int
    
    public static func < (lhs: RequestPriority, rhs: RequestPriority) -> Bool {
        lhs.value < rhs.value
    }
    
    public static let high = RequestPriority(value: 100)
    public static let normal = RequestPriority(value: 50)
    public static let low = RequestPriority(value: 10)
    public static let background = RequestPriority(value: 0)
    
    init(value: Int) {
        self.value = max(0, min(100, value))
    }
}
