#if os(iOS)
import SwiftUI

struct KilledDetailView: View {
    let item: KilledItem
    @Environment(\.openURL) private var openURL
    @AppStorage("display.fontChoice") private var fontRaw: String = FontChoice.system.rawValue
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                Divider().opacity(0.2)
                info
                if let link = item.link {
                    Button {
                        openURL(link)
                    } label: {
                        Label("Learn more", systemImage: "safari")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
                }
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(.white.opacity(0.12))
            )
            .padding()
        }
        .background(AppBackgroundView())
        .optionalFontDesign(FontChoice(rawValue: fontRaw)?.design)
        .tint(.primary)
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle().fill(.ultraThinMaterial).frame(width: 52, height: 52)
                Image(systemName: iconName)
                    .font(.title2)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(item.type.rawValue.capitalized)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack(spacing: 8) {
                    if let open = item.dateOpenString {
                        Label(open, systemImage: "calendar.badge.plus")
                            .font(.caption)
                            .padding(6)
                            .background(.thinMaterial, in: Capsule())
                    }
                    if let close = item.dateCloseString {
                        Label(close, systemImage: "calendar.badge.minus")
                            .font(.caption)
                            .padding(6)
                            .background(.thinMaterial, in: Capsule())
                    }
                }
            }
            Spacer()
        }
    }
    
    private var info: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overview")
                .font(.headline)
            Text(item.description)
                .font(.body)
                .foregroundStyle(.primary)
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
}

#endif
