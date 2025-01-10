import Foundation

public protocol RequestProtocol {
    var path: String { get }
    var method: HTTPMethod { get }
    var priority: RequestPriority { get }
    var headers: [String: String] { get }
    var parameters: RequestParameters? { get }
}

extension RequestProtocol {
    var headers: [String: String] { [:] }
    var parameters: RequestParameters? { nil }
}

public struct Request: RequestProtocol {
    public let path: String
    public let method: HTTPMethod
    public let priority: RequestPriority
    public var headers: [String: String]
    public var parameters: RequestParameters?
    
    public init(
        path: String,
        method: HTTPMethod = .get,
        priority: RequestPriority = .normal,
        headers: [String: String] = [:],
        parameters: RequestParameters? = nil
    ) {
        self.path = path
        self.method = method
        self.priority = priority
        self.headers = headers
        self.parameters = parameters
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    case head = "HEAD"
}

public struct RequestParameters {
    public var query: [String: Any]?
    public var body: BodyData?
    
    public init(query: [String : Any]? = nil, body: BodyData? = nil) {
        self.query = query
        self.body = body
    }
    
    public static func create(
        query: [String: Any]? = nil,
        body: BodyData? = nil
    ) -> Self {
        RequestParameters(query: query, body: body)
    }
}

public enum BodyData {
    case dictionary([String: Any])
    case encodable(Encodable)
    case raw(Data)
    case form([String: String])
    case multipart(MultipartData)
}
