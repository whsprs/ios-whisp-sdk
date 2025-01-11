import UIKit

extension UIColor {
    
    // MARK: - Init
    
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        precondition((0x0...0xFFFFFF).contains(rgb))
        precondition((0...1).contains(alpha))
        self.init(red: (rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF, blue: rgb & 0xFF, alpha: alpha)
    }

    private convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(displayP3Red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
    }
    
    // MARK: - Static
    
    static func rgb(_ hex: Int) -> UIColor {
        UIColor(rgb: hex)
    }
}
