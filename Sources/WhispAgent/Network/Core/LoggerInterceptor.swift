import Foundation

final class LoggerInterceptor: RequestInterceptor {
    
    // MARK: - Private Proeprties
    
    private let configuration: LoggerConfiguration
    private let requestBodyFormatter: NetworkDataFormatter
    private let responseBodyFormatter: NetworkDataFormatter
    private let logger: NetworkLogger
    private let dateFormatter: DateFormatter
    
    init(
        configuration: LoggerConfiguration = .full,
        requestBodyFormatter: NetworkDataFormatter = DefaultBodyFormatter(),
        responseBodyFormatter: NetworkDataFormatter = DefaultBodyFormatter(),
        logger: NetworkLogger = ConsoleLogger()
    ) {
        self.configuration = configuration
        self.requestBodyFormatter = requestBodyFormatter
        self.responseBodyFormatter = responseBodyFormatter
        self.logger = logger
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }
    
    init(
        configuration: LoggerConfiguration = .full,
        bodyFormatter: NetworkDataFormatter = DefaultBodyFormatter(),
        logger: NetworkLogger = ConsoleLogger()
    ) {
        self.configuration = configuration
        self.requestBodyFormatter = bodyFormatter
        self.responseBodyFormatter = bodyFormatter
        self.logger = logger
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }
    
    public func intercept(request: URLRequest) async throws -> URLRequest {
        let timestamp = dateFormatter.string(from: Date())
        var log = "🚀 [\(timestamp)] Sending request:\n"
        log += "    • URL: \(request.url?.absoluteString ?? "nil")\n"
        log += "    • Method: \(request.httpMethod ?? "GET")"
        
        if let headers = request.allHTTPHeaderFields {
            log += formatHeaders(headers)
        }
        
        if let body = request.httpBody {
            log += requestBodyFormatter.format(data: body)
        }
        
        logger.log(log)
        return request
    }
    
    public func intercept(response: URLResponse, data: Data) async throws -> (URLResponse, Data) {
        guard let httpResponse = response as? HTTPURLResponse else {
            return (response, data)
        }
        
        let timestamp = dateFormatter.string(from: Date())
        var log = "✅ [\(timestamp)] Received response:\n"
        log += "    • Status: \(httpResponse.statusCode)"
        
        let headers = httpResponse.allHeaderFields as? [String: Any] ?? [:]
        log += formatHeaders(headers)
        log += responseBodyFormatter.format(data: data)
        
        logger.log(log)
        return (response, data)
    }
    
    private func formatHeaders(_ headers: [String: Any]) -> String {
        let filteredHeaders: [String: Any] = {
            switch configuration.headers {
            case .all: return headers
            case .none: return [:]
            case .only(let allowed): return headers.filter { allowed.contains($0.key) }
            case .exclude(let excluded): return headers.filter { !excluded.contains($0.key) }
            }
        }()
        
        guard !filteredHeaders.isEmpty else { return "" }
        
        var result = "\n    • Headers:"
        filteredHeaders.forEach { key, value in
            result += "\n        - \(key): \(value)"
        }
        return result
    }
}
