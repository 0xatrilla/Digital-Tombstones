#if os(iOS)
import SwiftUI

public extension View {
    @ViewBuilder
    func optionalFontDesign(_ design: Font.Design?) -> some View {
        if let design {
            self.fontDesign(design)
        } else {
            self
        }
    }
}
#endif
