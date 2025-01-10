import Foundation

public protocol RequestInterceptor {
    func intercept(request: URLRequest) async throws -> URLRequest
    func intercept(response: URLResponse, data: Data) async throws -> (URLResponse, Data)
}
