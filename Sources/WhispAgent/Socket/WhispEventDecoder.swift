import Foundation
import Starscream

protocol WhispEventDecoder {
    func decode(event: WebSocketEvent) -> WhispEvent?
}

final class LiveWhispEventDecoder: WhispEventDecoder {
    
    // MARK: - Private Properties
    
    private let decoder: JSONDecoder
    private let isLoggingEnabled: Bool
    
    // MARK: - Init
    
    init(
        decoder: JSONDecoder,
        isLoggingEnabled: Bool
    ) {
        self.decoder = decoder
        self.isLoggingEnabled = isLoggingEnabled
    }
    
    // MARK: - Methods
    
    func decode(event: WebSocketEvent) -> WhispEvent? {
        switch event {
        case .connected:
            break
            
        case let .disconnected(reason, _):
            return .disconnected(reason: reason)
            
        case .text:
            break
            
        case let .binary(data):
            guard let event = try? decoder.decode(WhispEvent.self, from: data) else {
                return nil
            }
            
            return event
            
        case .pong:
            log("[Whisp] Socket: - Pong")
            
        case .ping:
            log("[Whisp] Socket: - Ping")
            
        case let .error(error):
            log("[Whisp] Socket: - \(error?.localizedDescription ?? "error occured")")
            
        case .viabilityChanged(let bool):
            log("[Whisp] Socket: - Viability changed: \(bool)")
            
        case .reconnectSuggested(let bool):
            log("[Whisp] Socket: - Reconnect suggested: \(bool)")
            
        case .cancelled:
            log("[Whisp] Socket: - Cancelled")
            
        case .peerClosed:
            log("[Whisp] Socket: - Peer closed")
        }
        
        return nil
    }
    
    // MARK: - Private
    
    private func log(_ message: String) {
        if isLoggingEnabled {
            print("[Whisp] Socket: - Peer closed")
        }
    }
}
