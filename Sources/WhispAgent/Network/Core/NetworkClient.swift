import Foundation

protocol NetworkClientProtocol {
    func execute(_ request: RequestProtocol) async throws -> Response
}

final class NetworkClient: NetworkClientProtocol {
    
    // MARK: - Private Properties
    
    private let configuration: NetworkConfiguration
    private let session: URLSessionProtocol
    private let requestBuilder: URLRequestBuilderProtocol
    private let interceptors: [RequestInterceptor]
    
    // MARK: - Init
    
    init(
        configuration: NetworkConfiguration,
        session: URLSessionProtocol,
        requestBuilder: URLRequestBuilderProtocol = URLRequestBuilder(),
        interceptors: [RequestInterceptor] = []
    ) {
        self.configuration = configuration
        self.requestBuilder = requestBuilder
        self.interceptors = interceptors
        self.session = session
    }
    
    // MARK: - Methods
    
    func execute(_ request: RequestProtocol) async throws -> Response {
        var urlRequest = try requestBuilder.createURLRequest(
            for: request,
            baseURL: configuration.baseURL,
            defaultHeaders: configuration.defaultHeaders
        )
        
        for interceptor in interceptors {
            urlRequest = try await interceptor.intercept(request: urlRequest)
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        
        var interceptedResponse = response
        var interceptedData = data
        for interceptor in interceptors {
            (interceptedResponse, interceptedData) = try await interceptor.intercept(
                response: interceptedResponse,
                data: interceptedData
            )
        }
        
        guard let httpResponse = interceptedResponse as? HTTPURLResponse else {
            throw NetworkClientError.invalidResponse
        }
        
        return Response(
            data: interceptedData,
            statusCode: httpResponse.statusCode,
            headers: httpResponse.allHeaderFields as? [String: String] ?? [:]
        )
    }
}
