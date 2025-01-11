import Foundation

public protocol URLRequestBuilderProtocol: Sendable {
    func createURLRequest(for request: RequestProtocol, baseURL: URL, defaultHeaders: [String: String]) throws -> URLRequest
}

public final class URLRequestBuilder: URLRequestBuilderProtocol, Sendable {
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - URLRequestBuilderProtocol
    
    public func createURLRequest(
        for request: RequestProtocol,
        baseURL: URL,
        defaultHeaders: [String: String]
    ) throws -> URLRequest {
        
        var components = URLComponents(
            url: baseURL.appendingPathComponent(request.path),
            resolvingAgainstBaseURL: true
        )
        
        if let queryParams = request.parameters?.query {
            components?.queryItems = queryParams.map { key, value in
                URLQueryItem(name: key, value: String(describing: value))
            }
        }
        
        guard let url = components?.url else {
            throw NetworkClientError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = defaultHeaders.merging(
            request.headers,
            uniquingKeysWith: { (_, new) in new }
        )
        
        if let bodyData = request.parameters?.body {
            try setBody(bodyData, for: &urlRequest)
        }
        
        return urlRequest
    }
    
    // MARK: - Private
    
    private func setBody(_ bodyData: BodyData, for request: inout URLRequest) throws {
        switch bodyData {
        case .dictionary(let dict):
            request.httpBody = try JSONSerialization.data(withJSONObject: dict)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        case .encodable(let encodable):
            request.httpBody = try JSONEncoder().encode(AnyEncodable(encodable))
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        case .form(let dict):
            let formData = dict
                .map { "\($0)=\($1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $1)" }
                .joined(separator: "&")
            request.httpBody = formData.data(using: .utf8)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
        case .multipart(let multipartData):
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = try createMultipartFormData(for: multipartData, boundary: boundary)
            
        case .raw(let data):
            request.httpBody = data
        }
    }
    
    private func createMultipartFormData(
        for multipartData: MultipartData,
        boundary: String
    ) throws -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        multipartData.parameters?.forEach { key, value in
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        multipartData.files.forEach { file in
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(file.mimeType.value)\r\n\r\n".data(using: .utf8)!)
            body.append(file.data)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
}

// MARK: - Private

private struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    
    init(_ encodable: Encodable) {
        _encode = encodable.encode
    }
    
    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
