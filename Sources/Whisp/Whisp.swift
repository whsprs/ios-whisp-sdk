import Foundation
import Starscream

public final class Whisp {

    // MARK: - Dependencies
    
    private let apiService: WhispAPIService
    private let webSocket: WebSocket
    private let eventDecoder: WhispEventDecoder
    private let eventEncoder: WhispEventEncoder
    
    // MARK: - Private Properties
    
    private let apiKey: String
    private let publicKey: String
    private let network: WhispNetwork
    
    // MARK: - Mutable Properties
    
    private var isInitialized = false
    
    // MARK: - Init
    
    init(
        apiKey: String,
        publicKey: String,
        network: WhispNetwork,
        apiService: WhispAPIService,
        webSocket: WebSocket,
        eventDecoder: WhispEventDecoder,
        eventEncoder: WhispEventEncoder
    ) {
        self.apiKey = apiKey
        self.publicKey = publicKey
        self.network = network
        self.apiService = apiService
        self.webSocket = webSocket
        self.eventDecoder = eventDecoder
        self.eventEncoder = eventEncoder
    }
    
    // MARK: - Methods
    
    public func setup() async throws {
        try await apiService.initialize(
            parameters: WhispInitializeRequestBody(
                api_key: apiKey,
                public_key: publicKey,
                network: network.value
            )
        )
        
        isInitialized = true
    }
    
    public func connect() async throws {
        guard isInitialized else {
            throw WhispError.notInitialized
        }
        
        webSocket.connect()
    }
    
    public func listen() -> AsyncStream<WhispEvent> {
        AsyncStream { [weak self] continuation in
            self?.webSocket.onEvent = { event in
                guard let whispEvent = self?.eventDecoder.decode(event: event) else {
                    return
                }
                
                continuation.yield(whispEvent)
            }
        }
    }
    
    // MARK: - Send
    
    public func send(message: WhispSendTextMessage) throws {
        webSocket.write(data: try eventEncoder.encode(data: message))
    }
    
    public func send(transactionId: String, txHash: String) throws {
        webSocket.write(
            data: try eventEncoder.encode(
                data: WhispSendTransactionTxHash(id: transactionId, txHash: txHash)
            )
        )
    }
    
    public func send(signedTransaction: WhispSendSignedTransaction) throws {
        webSocket.write(data: try eventEncoder.encode(data: signedTransaction))
    }
    
    public func send(declinedTransactionId: String) throws {
        webSocket.write(
            data: try eventEncoder.encode(
                data: WhispSendDeclinedTransaction(id: declinedTransactionId)
            )
        )
    }
    
    // MARK: - Disconnect
    
    public func disconnect() {
        webSocket.disconnect()
    }
}
