// This feature module targets iOS only; wrap SwiftUI usage to avoid macOS availability checks during indexing.
#if os(iOS)
import SwiftUI

public struct ContentView: View {
    @StateObject private var vm = KilledViewModel()
    @StateObject private var favorites = FavoritesStore()
    @State private var showSettings = false
    
    // Layout & density settings (shared enums in SettingsModel)
    @AppStorage("display.layout") private var layoutRaw: String = DisplayLayout.list.rawValue
    private var layout: DisplayLayout {
        get { DisplayLayout(rawValue: layoutRaw) ?? .list }
        set { layoutRaw = newValue.rawValue }
    }
    @AppStorage("display.gridDensity") private var densityRaw: String = GridDensity.comfortable.rawValue
    private var density: GridDensity {
        get { GridDensity(rawValue: densityRaw) ?? .comfortable }
        set { densityRaw = newValue.rawValue }
    }
    @AppStorage("display.fontChoice") private var fontRaw: String = FontChoice.system.rawValue
    private var fontChoice: FontChoice { FontChoice(rawValue: fontRaw) ?? .system }
    private var layoutBinding: Binding<DisplayLayout> {
        Binding(
            get: { DisplayLayout(rawValue: layoutRaw) ?? .list },
            set: { layoutRaw = $0.rawValue }
        )
    }
    private var densityBinding: Binding<GridDensity> {
        Binding(
            get: { GridDensity(rawValue: densityRaw) ?? .comfortable },
            set: { densityRaw = $0.rawValue }
        )
    }
    @AppStorage("filter.favoritesOnly") private var favoritesOnly: Bool = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                content
            }
            .navigationTitle("Killed by Google")
            .searchable(text: $vm.searchText, prompt: "Search products")
            // Large title for consistency with list; chips removed
            // (Year filter moved into Filter menu)
            .optionalFontDesign(fontChoice.design)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Toggle("Favorites only", isOn: $favoritesOnly)
                        Divider()
                        Picker("Type", selection: $vm.filter) {
                            ForEach(KilledViewModel.Filter.allCases) { f in
                                Text(f.title).tag(f)
                            }
                        }
                        Divider()
                        Picker("Year", selection: Binding<String>(
                            get: { vm.selectedYear ?? "All" },
                            set: { vm.selectedYear = ($0 == "All" ? nil : $0) }
                        )) {
                            Text("All").tag("All")
                            ForEach(vm.availableYears, id: \.self) { y in
                                Text(y).tag(y)
                            }
                        }
                        Divider()
                        Button {
                            vm.filter = .all
                            vm.selectedYear = nil
                            vm.searchText = ""
                            favoritesOnly = false
                        } label: {
                            Label("Clear Filters", systemImage: "xmark.circle")
                        }
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Layout", selection: layoutBinding) {
                            ForEach(DisplayLayout.allCases) { l in
                                Label(l.title, systemImage: l.icon).tag(l)
                            }
                        }
                        Divider()
                        Picker("Density", selection: densityBinding) {
                            ForEach(GridDensity.allCases) { d in
                                Label(d.title, systemImage: d.icon).tag(d)
                            }
                        }
                    } label: {
                        Label("Layout", systemImage: layout.icon)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityLabel("Settings")
                }
            }
        }
        .task { await vm.load() }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .environmentObject(favorites)
    }
    
    @ViewBuilder
    private var content: some View {
        if let error = vm.error {
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                Text(error)
                    .multilineTextAlignment(.center)
                Button("Retry") { Task { await vm.load() } }
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding()
        } else {
            Group {
                if layout == .list {
                    List {
                        ForEach(displaySections) { section in
                            Section {
                                ForEach(section.items) { item in
                                    NavigationLink {
                                        KilledDetailView(item: item)
                                    } label: {
                                        KilledRowView(item: item)
                                            .listRowSeparator(.hidden)
                                    }
                                    .listRowBackground(Color.clear)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        let isFav = favorites.isFavorite(item.id)
                                        Button {
                                            let added = favorites.toggle(item.id)
                                            added ? Haptics.success() : Haptics.light()
                                        } label: {
                                            Label(isFav ? "Unfavorite" : "Favorite", systemImage: isFav ? "star.slash" : "star")
                                        }
                                        .tint(.yellow)
                                    }
                                }
                            } header: {
                                Text(section.title)
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                            }
                            .headerProminence(.increased)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .refreshable { await vm.load() }
                } else {
                    GeometryReader { proxy in
                        let columns = gridColumns(for: proxy.size.width)
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(gridItems) { item in
                                    NavigationLink {
                                        KilledDetailView(item: item)
                                    } label: {
                                        KilledGridCardView(item: item)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .tint(.primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                    }
                    .refreshable { await vm.load() }
                }
            }
        }
    }
    
    // Grid sizing: guarantee a true grid with at least 2 columns on phones; varies by density
    fileprivate func gridColumns(for width: CGFloat) -> [GridItem] {
        let horizontalPadding: CGFloat = 32 // 16 + 16
        let spacing: CGFloat = {
            switch density { case .dense: return 12; case .comfortable: return 16; case .spacious: return 20 }
        }()
        let targetWidth: CGFloat = {
            switch density { case .dense: return 150; case .comfortable: return 170; case .spacious: return 200 }
        }()
        let available = max(0, width - horizontalPadding)
        let count = max(2, Int((available + spacing) / (targetWidth + spacing)))
        return Array(repeating: GridItem(.flexible(), spacing: spacing, alignment: .top), count: count)
    }

    private var displaySections: [KilledViewModel.YearSection] {
        guard favoritesOnly else { return vm.yearSections }
        let favFiltered = vm.yearSections.compactMap { section -> KilledViewModel.YearSection? in
            let items = section.items.filter { favorites.isFavorite($0.id) }
            return items.isEmpty ? nil : .init(id: section.id, title: section.title, items: items)
        }
        return favFiltered
    }

    private var gridItems: [KilledItem] {
        let base = vm.filteredItems
        return favoritesOnly ? base.filter { favorites.isFavorite($0.id) } : base
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Year chips removed; filters live in the Filter menu.

#endif
