#if os(iOS)
import SwiftUI

public enum BackgroundStyle: String, CaseIterable, Identifiable {
    case liquid
    case ocean
    case sunset
    case solidAuto
    
    public var id: String { rawValue }
    public var title: String {
        switch self {
        case .liquid: return "Liquid Gradient"
        case .ocean: return "Ocean Gradient"
        case .sunset: return "Sunset Gradient"
        case .solidAuto: return "Solid (Auto)"
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
