import ComposableArchitecture
import Dependencies
import Foundation

@Reducer
struct ChatFeature {
    
    // MARK: - Body
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .view(action):
                return reduce(state: &state, action: action)
                
            case let .reducer(action):
                return reduce(state: &state, action: action)
                
            case .delegate:
                return .none
            }
        }
    }
    
    // MARK: - Reducer
    
    private func reduce(state: inout State, action: Action.View) -> Effect<Action> {
        .none
    }
    
    private func reduce(state: inout State, action: Action.Reducer) -> Effect<Action> {
        .none
    }
}
