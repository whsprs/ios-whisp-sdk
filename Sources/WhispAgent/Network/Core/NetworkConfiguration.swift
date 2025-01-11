import Foundation

struct NetworkConfiguration: Sendable {
    
    // MARK: - Properties
    
    let baseURL: URL
    let defaultHeaders: [String: String]
    let timeout: TimeInterval
    
    // MARK: - Init
    
    init(
        baseURL: URL,
        defaultHeaders: [String: String] = [:],
        timeout: TimeInterval = 30
    ) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
        self.timeout = timeout
    }
}
