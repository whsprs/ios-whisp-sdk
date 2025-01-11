public struct WhispNetwork: Sendable {
    let value: String
    
    init(value: String) {
        self.value = value
    }
    
    // MARK: - Static
    
    public static let mainnetBeta = Self(value: "mainnet-beta")
    public static let devnet = Self(value: "devnet")
}
