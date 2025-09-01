import SwiftUI
import Foundation

// MARK: - iOS Version Compatibility
@available(iOS 18.0, *)
public struct iOSCompatibility {
    
    // MARK: - iOS 26+ Features with Fallbacks
    
    /// iOS 26+ ultra-thin material with fallback to thin material
    @available(iOS 26.0, *)
    public static var ultraThinMaterial: Material {
        .ultraThinMaterial
    }
    
    @available(iOS 18.0, *)
    public static var ultraThinMaterialFallback: Material {
        if #available(iOS 26.0, *) {
            return .ultraThinMaterial
        } else {
            return .thinMaterial
        }
    }
    
    /// iOS 26+ liquid spring animation with fallback to regular spring
    @available(iOS 26.0, *)
    public static var liquidSpring: Animation {
        .liquidSpring(response: 0.6, dampingFraction: 0.8)
    }
    
    @available(iOS 18.0, *)
    public static var liquidSpringFallback: Animation {
        if #available(iOS 26.0, *) {
            return .liquidSpring(response: 0.6, dampingFraction: 0.8)
        } else {
            return .spring(response: 0.6, dampingFraction: 0.8)
        }
    }
    
    /// iOS 26+ glass transition with fallback to regular transition
    @available(iOS 26.0, *)
    public static var glassTransition: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.8).combined(with: .opacity),
            removal: .scale(scale: 1.1).combined(with: .opacity)
        )
    }
    
    @available(iOS 18.0, *)
    public static var glassTransitionFallback: AnyTransition {
        if #available(iOS 26.0, *) {
            return .asymmetric(
                insertion: .scale(scale: 0.8).combined(with: .opacity),
                removal: .scale(scale: 1.1).combined(with: .opacity)
            )
        } else {
            return .asymmetric(
                insertion: .scale(scale: 0.9).combined(with: .opacity),
                removal: .scale(scale: 1.05).combined(with: .opacity)
            )
        }
    }
    
    /// iOS 26+ ambient computing features with fallback
    @available(iOS 26.0, *)
    public static var supportsAmbientComputing: Bool {
        true
    }
    
    @available(iOS 18.0, *)
    public static var supportsAmbientComputingFallback: Bool {
        if #available(iOS 26.0, *) {
            return true
        } else {
            return false
        }
    }
    
    /// iOS 26+ neural engine features with fallback
    @available(iOS 26.0, *)
    public static var supportsNeuralEngine: Bool {
        true
    }
    
    @available(iOS 18.0, *)
    public static var supportsNeuralEngineFallback: Bool {
        if #available(iOS 26.0, *) {
            return true
        } else {
            return false
        }
    }
}

// MARK: - View Extensions for Compatibility
@available(iOS 18.0, *)
public extension View {
    
    /// Apply ultra-thin material with fallback
    func compatibleUltraThinMaterial() -> some View {
        if #available(iOS 26.0, *) {
            return self.background(.ultraThinMaterial)
        } else {
            return self.background(.thinMaterial)
        }
    }
    
    /// Apply liquid spring animation with fallback
    func compatibleLiquidSpring() -> some View {
        if #available(iOS 26.0, *) {
            return self.animation(.liquidSpring(response: 0.6, dampingFraction: 0.8), value: UUID())
        } else {
            return self.animation(.spring(response: 0.6, dampingFraction: 0.8), value: UUID())
        }
    }
    
    /// Apply glass transition with fallback
    func compatibleGlassTransition() -> some View {
        if #available(iOS 26.0, *) {
            return self.transition(.asymmetric(
                insertion: .scale(scale: 0.8).combined(with: .opacity),
                removal: .scale(scale: 1.1).combined(with: .opacity)
            ))
        } else {
            return self.transition(.asymmetric(
                insertion: .scale(scale: 0.9).combined(with: .opacity),
                removal: .scale(scale: 1.05).combined(with: .opacity)
            ))
        }
    }
}

// MARK: - Conditional Compilation Helpers
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: - URLSession Compatibility
@available(iOS 18.0, *)
public struct URLSessionCompatibility {
    
    public static func shared() -> URLSession {
        #if canImport(FoundationNetworking)
        return URLSession.shared
        #else
        return URLSession.shared
        #endif
    }
}
