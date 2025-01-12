import ComposableArchitecture

extension ChatFeature {
    @CasePathable
    enum Action: ViewAction {
        enum View {
            case onAppear
        }
        
        enum Reducer {

        }
        
        enum Delegate {
            
        }
        
        case view(View)
        case reducer(Reducer)
        case delegate(Delegate)
    }
}
