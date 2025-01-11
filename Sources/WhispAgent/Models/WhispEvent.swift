public enum WhispEvent: Sendable {
    case textMessage(WhispTextMessage)
    case status(WhispStatus)
    case transactionRequest(WhispTransactionRequest)
    case disconnected(reason: String)
    case unknown
}

// MARK: - Parsing

extension WhispEvent: Decodable {
    enum EventType: String, Decodable {
        case text_message
        case status
        case transaction_request
        case unknown
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(EventType.self, forKey: .type)
        
        switch type {
        case .status:
            let data = try container.decode(WhispStatus.self, forKey: .data)
            self = .status(data)
        case .text_message:
            let data = try container.decode(WhispTextMessage.self, forKey: .data)
            self = .textMessage(data)
            
        case .transaction_request:
            let data = try container.decode(WhispTransactionRequest.self, forKey: .data)
            self = .transactionRequest(data)
            
        case .unknown:
            self = .unknown
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case data
    }
}

// MARK: - Text Message

public enum WhispTextMessageStatus: String, Sendable, Decodable {
    case processing
    case completed
    case failed
}

public struct WhispTextMessage: Sendable, Decodable {
    public let id: String
    public let text: String
    public let status: WhispTextMessageStatus
}

// MARK: - Status

public struct WhispStatus: Sendable, Decodable {
    public let id: String
    public let text: String
}

// MARK: - Transaction Request

public struct WhispTransactionRequest: Sendable, Decodable {
    let id: String
    let transaction: String
}

