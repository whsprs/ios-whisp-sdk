import Foundation

public protocol ResponseDecoder {
    func decode<T: Decodable>(responseType: T.Type, from response: Response) throws -> T
    func decode<E: Decodable & Error>(errorType: E.Type, from response: Response) throws -> E?
}

public final class DefaultResponseDecoder: ResponseDecoder {
    
    // MARK: - Private Properties
    
    private let jsonDecoder: JSONDecoder
    private let successRange = 200...299
    
    // MARK: - Init
    
    public init(jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = jsonDecoder
    }
    
    // MARK: - Methods
    
    public func decode<T: Decodable>(responseType: T.Type, from response: Response) throws -> T {
        guard successRange.contains(response.statusCode) else {
            throw NetworkClientError.httpError(statusCode: response.statusCode, data: response.data)
        }
        return try jsonDecoder.decode(T.self, from: response.data)
    }
    
    public func decode<E: Decodable & Error>(errorType: E.Type, from response: Response) throws -> E? {
        guard !successRange.contains(response.statusCode) else { return nil }
        return try? jsonDecoder.decode(E.self, from: response.data)
    }
}
