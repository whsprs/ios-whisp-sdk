import UIKit
import SwiftUI

/// Stylized *whisp* button for SwiftUI applications
/// Currently in development
public struct WhispButton: View, Equatable {
    
    // MARK: - Private Properties
    
    private let action: Command
    
    // MARK: - Init
    
    public init(action: Command) {
        self.action = action
    }
    
    public init(action: @escaping () -> Void) {
        self.action = Command { action() }
    }
    
    // MARK: - UI
    
    public var body: some View {
        Button {
            action.run()
        } label: {
            Image("transparent_whisp_logo_72x72", bundle: .module)
                .foregroundColor(Color.white)
                .frame(width: 72, height: 72)
                .clipShape(.circle)
                .contentShape(Rectangle())
        }
    }
}

/// Stylized *whisp* button for UIKit applications
/// Currently in development
final class UIWhispButton: UIView {

}
