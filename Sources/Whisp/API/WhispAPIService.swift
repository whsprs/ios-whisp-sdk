protocol WhispAPIService {
    func initialize(parameters: WhispInitializeRequestBody) async throws
}

public final class LiveWhispAPIService: WhispAPIService {
    
    // MARK: - Private Properties
    
    private let networkClient: NetworkClient
    
    // MARK: - Init
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - Methods
    
    func initialize(parameters: WhispInitializeRequestBody) async throws {
        _ = try await networkClient.execute(
            WhispAPI.initialize(parameters: parameters)
        )
    }
}
