import Foundation
import Starscream

public final class WhispAgentBuilder: Sendable {
    
    // MARK: - Static
    
    public static let shared = WhispAgentBuilder()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: Methods
    
    public func build(
        url: URL,
        webSocketUrl: URL,
        apiKey: String,
        publicKey: String,
        network: WhispNetwork,
        session: URLSession = .shared
    ) throws -> WhispAgent {
        
        let requestBuilder = URLRequestBuilder()
        
        let request = try requestBuilder.createURLRequest(
            for: WhispAPI.connect(apiKey: apiKey),
            baseURL: webSocketUrl,
            defaultHeaders: [:]
        )
        
        let apiService = LiveWhispAPIService(
            networkClient: NetworkClient(
                configuration: NetworkConfiguration(
                    baseURL: url
                ),
                session: session,
                requestBuilder: requestBuilder
            )
        )
        
        return WhispAgent(
            apiKey: apiKey,
            publicKey: publicKey,
            network: network,
            apiService: apiService,
            webSocket: WebSocket(request: request),
            eventDecoder: LiveWhispEventDecoder(
                decoder: JSONDecoder(),
                isLoggingEnabled: false
            ),
            eventEncoder: LiveWhispEventEncoder(
                encoder: JSONEncoder()
            )
        )
    }
}
