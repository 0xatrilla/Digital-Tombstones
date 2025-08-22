#if os(iOS)
import Foundation
import Combine

public final class FavoritesStore: ObservableObject {
    @Published private(set) var favorites: Set<String>
    private let key = "favorites.ids"
    private var cancellables = Set<AnyCancellable>()

    public init() {
        if let data = UserDefaults.standard.array(forKey: key) as? [String] {
            self.favorites = Set(data)
        } else {
            self.favorites = []
        }
        // Persist on change
        $favorites
            .sink { [weak self] set in
                guard let self else { return }
                UserDefaults.standard.set(Array(set), forKey: self.key)
            }
            .store(in: &cancellables)
    }

    public func isFavorite(_ id: String) -> Bool { favorites.contains(id) }

    public func toggle(_ id: String) -> Bool {
        var added = false
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
            added = true
        }
        return added
    }
}
#endif
