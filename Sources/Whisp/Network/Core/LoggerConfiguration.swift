public struct LoggerConfiguration: Sendable {
    public enum Headers: Sendable {
        case all
        case none
        case only([String])
        case exclude([String])
    }
    
    public let headers: Headers
    
    public static let minimal = LoggerConfiguration(
        headers: .only(["Content-Type", "Content-Length"])
    )
    
    public static let debugging = LoggerConfiguration(
        headers: .exclude(["Cookie", "Authorization"])
    )
    
    public static let full = LoggerConfiguration(
        headers: .all
    )
}
