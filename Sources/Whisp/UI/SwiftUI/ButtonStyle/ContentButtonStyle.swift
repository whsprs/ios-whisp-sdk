import SwiftUI

func ContentPrimaryFillButtonStyle() -> ContentFillButtonStyle { ContentFillButtonStyle(.primary) }
func ContentSecondaryFillButtonStyle() -> ContentFillButtonStyle { ContentFillButtonStyle(.secondary) }

struct ContentFillButton: Equatable {
    struct Style: Equatable {
        let foregroundColor: Color
        let backgroundColor: Color
        
        // MARK: - Static
        
        static let primaryIdle = Self(
            foregroundColor: Color(rgb: 0xFFFFFF),
            backgroundColor: Color(rgb: 0x000000)
        )
        
        static let primaryDisabled = Self(
            foregroundColor: Color(rgb: 0xC7C7CC),
            backgroundColor: Color(rgb: 0x000000).opacity(0.04)
        )
        
        static let secondaryIdle = Self(
            foregroundColor: Color(rgb: 0x000000),
            backgroundColor: Color(rgb: 0x000000).opacity(0.04)
        )
        
        static let secondaryDisabled = Self(
            foregroundColor: Color(rgb: 0xC7C7CC),
            backgroundColor: Color(rgb: 0x000000).opacity(0.04)
        )
    }
    
    let font: Font
    let idle: Style
    let disabled: Style
    
    // MARK: - Static
    
    static let primary = Self(
        font: .system(size: 20, weight: .semibold),
        idle: .primaryIdle,
        disabled: .primaryDisabled
    )
    
    static let secondary = Self(
        font: .system(size: 20, weight: .semibold),
        idle: .secondaryIdle,
        disabled: .secondaryDisabled
    )
}

struct ContentFillButtonStyle: ButtonStyle {
    
    // MARK: - Private Properties
    
    private let button: ContentFillButton
    
    // MARK: - Init
    
    init(_ button: ContentFillButton) {
        self.button = button
    }
    
    // MARK: - ButtonStyle
    
    func makeBody(configuration: Configuration) -> some View {
        Button(configuration: configuration, button: button)
    }
    
    // MARK: - Private
    
    private struct Button: View {

        // MARK: - Private Properties

        @Environment(\.isEnabled) private var isEnabled: Bool

        // MARK: - Properties

        let configuration: ButtonStyle.Configuration
        let button: ContentFillButton

        // MARK: - Private Properties

        private var foregroundColor: Color {
            isEnabled
                ? button.idle.foregroundColor
                : button.disabled.foregroundColor
        }

        private var backgroundColor: Color {
            isEnabled
                ? button.idle.backgroundColor
                : button.disabled.backgroundColor
        }

        // MARK: - UI

        var body: some View {
            let foregroundColor = foregroundColor.opacity(configuration.isPressed ? 0.75 : 1)
            let background = backgroundColor.opacity(configuration.isPressed ? 0.75 : 1)
            
            configuration.label
                .font(button.font)
                .multilineTextAlignment(.center)
                .foregroundColor(foregroundColor)
                .animation(.easeInOut(duration: 0.1), value: foregroundColor)
                .background(background)
                .animation(.easeInOut(duration: 0.1), value: background)
                .haptic(isPressed: configuration.isPressed)
        }
    }
}
