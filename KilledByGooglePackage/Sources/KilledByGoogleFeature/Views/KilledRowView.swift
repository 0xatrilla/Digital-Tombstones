#if os(iOS)
import SwiftUI

struct KilledRowView: View {
    let item: KilledItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 44, height: 44)
                Image(systemName: iconName)
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(item.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                    Spacer()
                    if let close = item.dateCloseString {
                        Text(close)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                HStack(spacing: 8) {
                    Label(item.type.rawValue.capitalized, systemImage: "tag")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.thinMaterial, in: Capsule())
                }
            }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(.white.opacity(0.2))
        )
    }
    
    private var iconName: String {
        switch item.type {
        case .app: return "app"
        case .service: return "gearshape"
        case .hardware: return "cpu"
        default: return "questionmark"
        }
    }
}

#endif
