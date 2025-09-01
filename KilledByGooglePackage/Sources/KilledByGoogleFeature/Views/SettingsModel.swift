#if os(iOS)
import SwiftUI

public enum BackgroundStyle: String, CaseIterable, Identifiable {
    case liquid
    case ocean
    case sunset
    case google
    case solidAuto
    
    public var id: String { rawValue }
    public var title: String {
        switch self {
        case .liquid: return "Liquid Gradient"
        case .ocean: return "Ocean Gradient"
        case .sunset: return "Sunset Gradient"
        case .google: return "Google"
        case .solidAuto: return "Solid (Auto)"
        }
    }
}

public extension BackgroundStyle {
    var tint: Color {
        switch self {
        case .liquid:
            return .indigo
        case .ocean:
            return .teal
        case .sunset:
            return .orange
        case .google:
            // Google blue #4285F4
            return Color(red: 0.2588, green: 0.5216, blue: 0.9569)
        case .solidAuto:
            return .blue
        }
    }
    
    /// Get the appropriate material based on iOS version
    @available(iOS 18.0, *)
    var compatibleMaterial: Material {
        switch self {
        case .liquid, .ocean, .sunset, .google:
            if #available(iOS 26.0, *) {
                return .ultraThinMaterial
            } else {
                return .thinMaterial
            }
        case .solidAuto:
            return .regularMaterial
        }
    }
}

public enum FontChoice: String, CaseIterable, Identifiable {
    case system
    case rounded
    case serif
    case monospaced
    
    public var id: String { rawValue }
    public var title: String {
        switch self {
        case .system: return "System"
        case .rounded: return "Rounded"
        case .serif: return "Serif"
        case .monospaced: return "Monospaced"
        }
    }
    
    public var design: Font.Design? {
        switch self {
        case .system: return nil
        case .rounded: return .rounded
        case .serif: return .serif
        case .monospaced: return .monospaced
        }
    }
}

public enum DisplayLayout: String, CaseIterable, Identifiable {
    case list, grid
    public var id: String { rawValue }
    public var title: String { self == .list ? "List" : "Grid" }
    public var icon: String { self == .list ? "list.bullet" : "square.grid.2x2" }
}

public enum GridDensity: String, CaseIterable, Identifiable {
    case dense, comfortable, spacious
    public var id: String { rawValue }
    public var title: String {
        switch self { case .dense: return "Compact"; case .comfortable: return "Comfortable"; case .spacious: return "Spacious" }
    }
    public var icon: String {
        switch self { case .dense: return "square.grid.3x2.fill"; case .comfortable: return "square.grid.2x2"; case .spacious: return "rectangle.grid.1x2" }
    }
}
#endif

