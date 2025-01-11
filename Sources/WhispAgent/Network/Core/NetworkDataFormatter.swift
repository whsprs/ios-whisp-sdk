import Foundation

protocol NetworkDataFormatter {
    func format(data: Data) -> String
}

extension NetworkDataFormatter {
    static var `default`: DefaultBodyFormatter.Type {
        DefaultBodyFormatter.self
    }
}

struct DefaultBodyFormatter: NetworkDataFormatter {
    enum Strategy {
        case full
        case disabled
        case truncated(maxLines: Int, maxCharacters: Int)
    }
    
    // MARK: - Static
    
    static func full() -> Self {
        Self(strategy: .full)
    }
    
    static func disabled() -> Self {
        Self(strategy: .disabled)
    }
    
    static func truncated(maxLines: Int, maxCharacters: Int) -> Self {
        Self(strategy: .truncated(maxLines: maxLines, maxCharacters: maxCharacters))
    }
    
    // MARK: - Private Properties
    
    private let strategy: Strategy
    
    // MARK: - Init
    
    init(strategy: Strategy = .full) {
        self.strategy = strategy
    }
    
    // MARK: - NetworkDataFormatter
    
    func format(data: Data) -> String {
        switch strategy {
        case .disabled:
            return ""
        case .full:
            return formatFullBody(data)
        case .truncated(let maxLines, let maxChars):
            return formatTruncatedBody(data, maxLines: maxLines, maxChars: maxChars)
        }
    }
    
    // MARK: - Private
    
    private func formatFullBody(_ data: Data) -> String {
        guard let bodyString = prettyPrintJSON(data) else { return "" }
        
        var result = "\n    • Body:\n"
        result += bodyString.components(separatedBy: .newlines)
            .map { "        \($0)" }
            .joined(separator: "\n")
        return result
    }
    
    private func formatTruncatedBody(_ data: Data, maxLines: Int, maxChars: Int) -> String {
        guard let bodyString = prettyPrintJSON(data) else { return "" }
        
        var truncated = bodyString
        if truncated.count > maxChars {
            truncated = String(truncated.prefix(maxChars)) + "\n... (truncated)"
        }
        
        let lines = truncated.components(separatedBy: .newlines)
        if lines.count > maxLines {
            truncated = lines.prefix(maxLines).joined(separator: "\n") + "\n... (truncated)"
        }
        
        var result = "\n    • Body:\n"
        result += truncated.components(separatedBy: .newlines)
            .map { "        \($0)" }
            .joined(separator: "\n")
        return result
    }
    
    private func formatSize(_ data: Data) -> String {
        ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .file)
    }
    
    private func prettyPrintJSON(_ data: Data) -> String? {
        guard let json = try? JSONSerialization.jsonObject(with: data),
              let prettyData = try? JSONSerialization.data(
                withJSONObject: json,
                options: [.prettyPrinted, .sortedKeys]
              ),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return nil
        }
        return prettyString
    }
}
