import Foundation

public struct Response: Sendable {
    public let data: Data
    public let statusCode: Int
    public let headers: [String: String]
}
