import SwiftUI

struct TTColors {
    static let primary: Color = Color(hex: 0xf4e041)
    static let secondary: Color = Color(hex: 0x00bdd3)
    static let secondaryDrk: Color = Color(hex: 0x009bbd)
    
    static let btnPres: Color = Color(hex: 0xffc700)
    static let btnDis: Color = Color(hex: 0xdedede)
}

extension Color {
    init(hex: UInt32) {
        self.init(
            red:       Double((hex >> 16) & 0xFF) / 256.0,
            green:     Double((hex >> 8) & 0xFF) / 256.0,
            blue:      Double(hex & 0xFF) / 256.0
        )
    }
}
