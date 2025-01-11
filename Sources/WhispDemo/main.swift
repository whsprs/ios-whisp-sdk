import WhispAgent
import Foundation

struct WhispDemo {
    /// Needed only for demonstration purpose only
    nonisolated(unsafe) private static var hasProcessingEvent = false
    /// Needed only for demonstration purpose only
    nonisolated(unsafe) private static var whispAgent: WhispAgent!
    /// Needed only for demonstration purpose only
    nonisolated(unsafe) private static var baseUrl = ""
    /// Needed only for demonstration purpose only
    nonisolated(unsafe) private static var websocketBaseUrl = ""
    
    // MARK: - Main
    
    static func run() async throws {
        if URL(string: baseUrl) == nil {
            print("Write API URL:")
            guard let baseUrl = readLine() else {
                print("No API URL provided. Exiting.")
                return
            }
            
            Self.baseUrl = baseUrl
        }
        
        if URL(string: websocketBaseUrl) == nil {
            print("Write WebSocket URL:")
            guard let websocketBaseUrl = readLine() else {
                print("No WebSocket URL provided. Exiting.")
                return
            }
            
            Self.websocketBaseUrl = websocketBaseUrl
        }
        
        print("Write your API key:")
        guard let apiKey = readLine() else {
            print("No API key provided. Exiting.")
            return
        }
        
        print("Write your public key:")
        guard let publicKey = readLine() else {
            print("No public key provided. Exiting.")
            return
        }
        
        print("\n\n")
        
        whispAgent = try WhispAgentBuilder.shared.build(
            url: URL(string: baseUrl)!,
            webSocketUrl: URL(string: websocketBaseUrl)!,
            apiKey: apiKey,
            publicKey: publicKey,
            network: .devnet
        )
        
        try await whispAgent.setup()
        try await whispAgent.connect()
        
        let consoleManager = ConsoleMessageManager()
        
        // MARK: - Observe Whisp Events
        
        Task.detached {
            for await event in whispAgent.listen() {
                hasProcessingEvent = true
                
                switch event {
                case let .textMessage(message):
                    consoleManager.updateMessage(message)
                    
                case let .transactionRequest(transactionRequest):
                    print("> Received transaction request: \(transactionRequest)")
                    /// App can handle this event in two ways:
                    /// 1. sign transaction, send it and tell transaction `tx_hash` to whisp:
                    ///     - `whisp.send(transactionId: transactionRequest.id, txHash: txHash)`
                    /// 2. sign transaction, make base64 serialization and send it to whisp:
                    ///     - `whisp.send(signedTransaction: WhispAgentSendSignedTransaction(id: transactionRequest.id, data: data))`
                    /// 3. decline transaction request from whisp using the following method:
                    ///     - `whisp.send(declinedTransactionId: transactionRequest.id))`
                    
                case let .status(status):
                    print("> \(status.text)")
                    
                case let .disconnected(reason):
                    if reason.isEmpty {
                        print("> Chat ended")
                    } else {
                        print("> Disconnected: \(reason)")
                    }
                    
                case .unknown:
                    print("> Warning: Received unknown event")
                }
                
                hasProcessingEvent = false
            }
        }
        
        // MARK: - User Input
        
        Task.detached {
            while true {
                guard
                    hasProcessingEvent == false,
                    let input = readLine(strippingNewline: true)
                else {
                    return try await Task.sleep(nanoseconds: 200_000_000)
                }
                
                if input.lowercased() == "quit" || input.lowercased() == "exit" {
                    print("Exiting now.")
                    exit(0)
                    
                } else {
                    try whispAgent.send(message: WhispAgentSendTextMessage(text: input))
                }
            }
        }
        
        while true {
            try await Task.sleep(nanoseconds: 1_000_000_000)
        }
    }
}

Task {
    do {
        try await WhispDemo.run()
    } catch {
        print("Error: \(error)")
        exit(1)
    }
}

dispatchMain()
