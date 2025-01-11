import UIKit

extension UIApplication {
    
    // MARK: - Properties
    
    var keyWindowInForegroundScenes: UIWindow? {
        foregroundWindows.first(where: \.isKeyWindow)
    }
    
    var foregroundWindows: [UIWindow] {
        foregroundScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
    }
    
    var foregroundScenes: [UIScene] {
        connectedScenes
            .filter { $0.activationState != .unattached }
    }
    
    // MARK: - Methods
    
    func endEditing(_ force: Bool) {
        UIApplication.shared.connectedScenes
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?
            .windows
            .first?
            .endEditing(force)
    }
}
