import WhispAgent
import Darwin

private struct MessageStatus {
    let id: String
    let completed: Bool
}

final class ConsoleMessageManager {

    // MARK: - Private Properties

    private var lastMessage: WhispTextMessage?

    // MARK: - Methods

    func updateMessage(_ message: WhispTextMessage) {
        lastMessage = message 
        printUpdatingLine("> \(message.text)")
            
        if message.status == .completed {
            print("")
        }
    }
    
    // MARK: - Private
    
    func printUpdatingLine(_ text: String) {
        print("\u{1B}[2K\r", terminator: "")
        print(text, terminator: "")
        fflush(stdout)
    }
}
