public enum WhispAgentSendEvent: String, Codable {
    case text_message
    case tx_hash
    case signed_transaction
    case decline_transaction
}

// MARK: - Text Message

public struct WhispAgentSendTextMessage: Encodable {
    public struct Data: Encodable {
        /// User text message to whisp
        public let text: String
    }
    
    /// Describes send event type
    public let type = WhispAgentSendEvent.text_message
    /// Describes send event data
    public let data: Data
    
    /// Returns user text message event
    /// - Parameter text: User text message to whisp
    public init(text: String) {
        self.data = Data(text: text)
    }
}

// MARK: - Transaction

public struct WhispAgentSendDeclinedTransaction: Encodable {
    public struct Data: Encodable {
        /// Whisp transaction identifier
        public let id: String
    }
    
    /// Describes send event type
    public let type = WhispAgentSendEvent.decline_transaction
    /// Describes send event data
    public let data: Data
    
    /// Returns declined transaction event
    /// - Parameter id: Whisp transaction identifier
    init(id: String) {
        self.data = Data(id: id)
    }
}

public struct WhispAgentSendTransactionTxHash: Encodable {
    public struct Data: Encodable {
        /// Whisp transaction identifier
        public let id: String
        public let tx_hash: String
    }
    
    /// Describes send event type
    public let type = WhispAgentSendEvent.tx_hash
    /// Describes send event data
    public let data: Data
    
    /// Returns declined transaction event
    /// - Parameter id: Whisp transaction identifier
    init(id: String, txHash: String) {
        self.data = Data(id: id, tx_hash: txHash)
    }
}

public struct WhispAgentSendSignedTransaction: Encodable {
    public struct Data: Encodable {
        /// Whisp transaction identifier
        public let id: String
        /// Signed transaction (base64)
        public let signed_transaction: String
    }
    
    /// Describes send event type
    public let type = WhispAgentSendEvent.signed_transaction
    /// Describes send event data
    public let data: Data
    
    /// Returns event with signed transaction from whisp
    /// - Parameters:
    ///   - id: Whisp transaction identifier
    ///   - signed_transaction: Signed transaction (base64)
    public init(
        id: String,
        signedTransaction: String
    ) {
        self.data = Data(id: id, signed_transaction: signedTransaction)
    }
}
