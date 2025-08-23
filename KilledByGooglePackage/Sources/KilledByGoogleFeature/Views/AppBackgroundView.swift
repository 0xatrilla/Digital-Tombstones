#if os(iOS)
import SwiftUI

public struct AppBackgroundView: View {
    @AppStorage("display.backgroundStyle") private var styleRaw: String = BackgroundStyle.liquid.rawValue
    @Environment(\.colorScheme) private var colorScheme
    
    private var style: BackgroundStyle { BackgroundStyle(rawValue: styleRaw) ?? .liquid }
    
    public init() {}
    
    public var body: some View {
        Group {
            switch style {
            case .liquid:
                LiquidBackground()
            case .ocean:
                gradientBackground(colors: [
                    .teal.opacity(0.35),
                    .blue.opacity(0.30),
                    .indigo.opacity(0.35)
                ])
            case .sunset:
                gradientBackground(colors: [
                    .orange.opacity(0.35),
                    .pink.opacity(0.30),
                    .purple.opacity(0.35)
                ])
            case .google:
                // Google brand colors: Blue, Red, Yellow, Green
                gradientBackground(colors: [
                    Color(red: 0.2588, green: 0.5216, blue: 0.9569).opacity(0.35), // #4285F4
                    Color(red: 0.9176, green: 0.2627, blue: 0.2078).opacity(0.30), // #EA4335
                    Color(red: 0.9843, green: 0.7373, blue: 0.0196).opacity(0.30), // #FBBC05
                    Color(red: 0.2039, green: 0.6588, blue: 0.3255).opacity(0.35)  // #34A853
                ])
            case .solidAuto:
                Color(.systemBackground).ignoresSafeArea()
            }
        }
    }
    
    @ViewBuilder
    private func gradientBackground(colors: [Color]) -> some View {
        ZStack {
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
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
    AppBackgroundView()
}
#endif

