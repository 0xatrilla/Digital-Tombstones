import Foundation
import Combine

@MainActor
final class KilledViewModel: ObservableObject {
    @Published var items: [KilledItem] = []
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    // Search & Filter
    @Published var searchText: String = ""
    @Published var filter: Filter = .all
    
    enum Filter: String, CaseIterable, Identifiable {
        case all, app, service, hardware
        var id: String { rawValue }
        var title: String {
            switch self { case .all: return "All"; case .app: return "App"; case .service: return "Service"; case .hardware: return "Hardware" }
        }
        var typeMatch: KilledItem.ItemType? {
            switch self { case .all: return nil; case .app: return .app; case .service: return .service; case .hardware: return .hardware }
        }
    }
    
    struct YearSection: Identifiable, Equatable {
        let id: String
        let title: String
        let items: [KilledItem]
    }
    
    var filteredItems: [KilledItem] {
        var arr = items
        if let match = filter.typeMatch {
            arr = arr.filter { $0.type == match }
        }
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !q.isEmpty {
            arr = arr.filter { $0.name.lowercased().contains(q) || $0.description.lowercased().contains(q) }
        }
        return arr
    }
    
    var yearSections: [YearSection] {
        let cal = Calendar(identifier: .gregorian)
        let groups = Dictionary(grouping: filteredItems, by: { (item) -> String in
            if let d = item.dateClose { return String(cal.component(.year, from: d)) }
            return "Unknown"
        })
        let numericYears = groups.keys.compactMap { Int($0) }.sorted(by: >)
        var result: [YearSection] = numericYears.map { y in
            let key = String(y)
            return YearSection(id: key, title: key, items: groups[key] ?? [])
        }
        if let unknown = groups["Unknown"], !unknown.isEmpty {
            result.append(YearSection(id: "Unknown", title: "Unknown", items: unknown))
        }
        return result
    }
    
    private let service: KilledServiceProtocol
    
    init(service: KilledServiceProtocol = KilledService()) {
        self.service = service
    }
    
    func load() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            var fetched = try await service.fetchItems()
            // Sort by close date desc, then name
            fetched.sort { a, b in
                switch (a.dateClose, b.dateClose) {
                case let (l?, r?): return l > r
                case (nil, nil): return a.name < b.name
                case (nil, _): return false
                case (_, nil): return true
                }
            }
            self.items = fetched
            self.error = nil
        } catch {
            self.error = (error as? LocalizedError)?.errorDescription ?? String(describing: error)
        }
    }
}
