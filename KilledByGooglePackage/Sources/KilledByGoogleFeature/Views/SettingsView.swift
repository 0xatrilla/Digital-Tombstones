#if os(iOS)
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    
    // AppStorage-backed settings
    @AppStorage("display.layout") private var layoutRaw: String = DisplayLayout.list.rawValue
    @AppStorage("display.gridDensity") private var densityRaw: String = GridDensity.comfortable.rawValue
    @AppStorage("display.fontChoice") private var fontRaw: String = FontChoice.system.rawValue
    @AppStorage("display.backgroundStyle") private var bgRaw: String = BackgroundStyle.liquid.rawValue
    
    private var layout: Binding<DisplayLayout> {
        Binding(
            get: { DisplayLayout(rawValue: layoutRaw) ?? .list },
            set: { layoutRaw = $0.rawValue }
        )
    }
    private var density: Binding<GridDensity> {
        Binding(
            get: { GridDensity(rawValue: densityRaw) ?? .comfortable },
            set: { densityRaw = $0.rawValue }
        )
    }
    private var fontChoice: Binding<FontChoice> {
        Binding(
            get: { FontChoice(rawValue: fontRaw) ?? .system },
            set: { fontRaw = $0.rawValue }
        )
    }
    private var backgroundStyle: Binding<BackgroundStyle> {
        Binding(
            get: { BackgroundStyle(rawValue: bgRaw) ?? .liquid },
            set: { bgRaw = $0.rawValue }
        )
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Display Layout") {
                    Picker("Layout", selection: layout) {
                        ForEach(DisplayLayout.allCases) { l in
                            Label(l.title, systemImage: l.icon).tag(l)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("Grid Density", selection: density) {
                        ForEach(GridDensity.allCases) { d in
                            Label(d.title, systemImage: d.icon).tag(d)
                        }
                    }
                    .pickerStyle(.segmented)
                    .disabled(layout.wrappedValue == .list)
                    .opacity(layout.wrappedValue == .list ? 0.5 : 1)
                }
                
                Section("Typography") {
                    Picker("Font", selection: fontChoice) {
                        ForEach(FontChoice.allCases) { f in
                            Text(f.title).tag(f)
                        }
                    }
                }
                
                Section("Background") {
                    Picker("Style", selection: backgroundStyle) {
                        ForEach(BackgroundStyle.allCases) { s in
                            Text(s.title).tag(s)
                        }
                    }
                    
                    // Small live preview
                    ZStack { AppBackgroundView() }
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .strokeBorder(.separator)
                        )
                }
                
                Section {
                    Button(role: .destructive) { resetAll() } label: {
                        Label("Reset to Defaults", systemImage: "arrow.counterclockwise")
                    }
                }
                
                Section("Credits") {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Thank you")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Button {
                            if let url = URL(string: "https://killedbygoogle.com") {
                                openURL(url)
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Text("killedbygoogle.com")
                                    .font(.footnote.weight(.semibold))
                                Image(systemName: "arrow.up.right.square")
                                    .font(.footnote)
                            }
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.tint)
                        .accessibilityLabel("Open killedbygoogle.com in browser")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    private func resetAll() {
        layoutRaw = DisplayLayout.list.rawValue
        densityRaw = GridDensity.comfortable.rawValue
        fontRaw = FontChoice.system.rawValue
        bgRaw = BackgroundStyle.liquid.rawValue
    }
}

#Preview { SettingsView() }
#endif

