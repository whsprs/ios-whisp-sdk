import Foundation

protocol WhispEventEncoder {
    func encode(data: Encodable) throws -> Data
}

final class LiveWhispEventEncoder: WhispEventEncoder {
    
    // MARK: - Private Properties
    
    private let encoder: JSONEncoder
    
    // MARK: - Init
    
    init(encoder: JSONEncoder) {
        self.encoder = encoder
    }
    
    // MARK: - WhispEventEncoder
    
    func encode(data: Encodable) throws -> Data {
        try encoder.encode(data)
    }
}
