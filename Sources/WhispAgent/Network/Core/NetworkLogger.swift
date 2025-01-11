protocol NetworkLogger {
    func log(_ message: String)
}

struct ConsoleLogger: NetworkLogger {
    init() {}
    func log(_ message: String) {
        print(message)
    }
}
