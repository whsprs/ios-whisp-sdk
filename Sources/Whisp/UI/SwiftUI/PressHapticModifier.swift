import Dependencies
import SwiftUI

struct PressHapticModifier: ViewModifier {

    // MARK: - Dependencies

    @Dependency(\.smartPressFeedbackGenerator)
    private var smartPressFeedbackGenerator: SmartPressFeedbackGenerator
    
    // MARK: - Private Properties

    private let trigger: Bool

    // MARK: - Init

    init(trigger: Bool) {
        self.trigger = trigger
    }

    // MARK: - ViewModifier

    func body(content: Content) -> some View {
        content
            .onChange(of: trigger) { _ in
                trigger
                    ? smartPressFeedbackGenerator.press()
                    : smartPressFeedbackGenerator.release()
            }
    }
}

extension View {
    func haptic(isPressed: Bool) -> some View {
        self.modifier(PressHapticModifier(trigger: isPressed))
    }
}
