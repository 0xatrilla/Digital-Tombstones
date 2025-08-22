#if os(iOS)
import SwiftUI

struct LiquidBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color.blue.opacity(0.35),
                Color.purple.opacity(0.30),
                Color.indigo.opacity(0.35)
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 300, height: 300)
                .blur(radius: 30)
                .offset(x: -120, y: -220)
                .blendMode(.plusLighter)
            
            RoundedRectangle(cornerRadius: 200, style: .continuous)
                .fill(.ultraThinMaterial)
                .frame(width: 420, height: 420)
                .blur(radius: 40)
                .offset(x: 160, y: 260)
                .blendMode(.plusLighter)
        }
    }
}

#Preview {
    LiquidBackground()
}

#endif
