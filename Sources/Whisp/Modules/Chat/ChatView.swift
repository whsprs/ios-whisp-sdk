import SwiftUI
import ComposableArchitecture
import Combine

@ViewAction(for: ChatFeature.self)
struct ChatView: View {
    
    @Perception.Bindable var store: StoreOf<ChatFeature>
    
    // MARK: - UI
    
    var body: some View {
        Color.clear
            .onAppear {
                send(.onAppear)
            }
    }
}
