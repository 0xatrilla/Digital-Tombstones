#if os(iOS)
import SwiftUI
import UIKit

struct KilledRowView: View {
    let item: KilledItem
    @EnvironmentObject private var favorites: FavoritesStore
    
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
                    HStack(spacing: 6) {
                        if let close = item.dateCloseString {
                            Text(close)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        if favorites.isFavorite(item.id) {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundStyle(.yellow)
                                .accessibilityHidden(true)
                        }
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
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint("Opens detailed view")
        .contextMenu {
            let isFav = favorites.isFavorite(item.id)
            Button {
                let added = favorites.toggle(item.id)
                added ? Haptics.success() : Haptics.light()
            } label: {
                Label(isFav ? "Remove from Favorites" : "Add to Favorites", systemImage: isFav ? "star.slash" : "star")
            }
            if let url = item.link {
                ShareLink(item: url) {
                    Label("Share Link", systemImage: "square.and.arrow.up")
                }
                Button {
                    UIPasteboard.general.string = url.absoluteString
                    Haptics.light()
                } label: {
                    Label("Copy Link", systemImage: "doc.on.doc")
                }
            }
        }
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
