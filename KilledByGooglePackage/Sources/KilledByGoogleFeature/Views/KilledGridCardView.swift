#if os(iOS)
import SwiftUI

struct KilledGridCardView: View {
    let item: KilledItem

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 36, height: 36)
                    Image(systemName: iconName)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
                Spacer()
                if let close = item.dateCloseString {
                    Text(close)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Text(item.name)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(3)
                .multilineTextAlignment(.leading)

            Spacer(minLength: 0)

            HStack {
                Label(item.type.rawValue.capitalized, systemImage: "tag")
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.thinMaterial, in: Capsule())
                Spacer(minLength: 0)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 140)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(.white.opacity(0.2))
        )
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .tint(.primary)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint("Opens detailed view")
    }

    private var iconName: String {
        switch item.type {
        case .app: return "app"
        case .service: return "gearshape"
        case .hardware: return "cpu"
        default: return "questionmark"
        }
    }

    private var accessibilityLabel: String {
        var parts: [String] = [item.name]
        parts.append(item.type.rawValue.capitalized)
        if let date = item.dateCloseString { parts.append(date) }
        return parts.joined(separator: ", ")
    }
}
#endif
