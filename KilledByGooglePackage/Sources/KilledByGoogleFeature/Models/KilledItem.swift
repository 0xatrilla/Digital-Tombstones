import Foundation

public struct KilledItem: Identifiable, Codable, Equatable {
    public let name: String
    public let dateOpen: Date?
    public let dateClose: Date?
    public let link: URL?
    public let description: String
    public let type: ItemType
    
    public enum ItemType: String, Codable, CaseIterable {
        case app
        case service
        case hardware
        case unknown
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let raw = (try? container.decode(String.self)) ?? "unknown"
            self = ItemType(rawValue: raw) ?? .unknown
        }
    }
    
    public var id: String { "\(name)-\(dateCloseString ?? "")" }
    
    public var dateOpenString: String? { formatted(dateOpen) }
    public var dateCloseString: String? { formatted(dateClose) }
    
    private func formatted(_ date: Date?) -> String? {
        guard let d = date else { return nil }
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateStyle = .medium
        return f.string(from: d)
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case dateOpen
        case dateClose
        case link
        case description
        case type
    }

    // Public memberwise initializer for convenience (previews, tests)
    public init(name: String, dateOpen: Date?, dateClose: Date?, link: URL?, description: String, type: ItemType) {
        self.name = name
        self.dateOpen = dateOpen
        self.dateClose = dateClose
        self.link = link
        self.description = description
        self.type = type
    }
    
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try c.decode(String.self, forKey: .name)
        self.description = try c.decode(String.self, forKey: .description)
        self.type = (try? c.decode(ItemType.self, forKey: .type)) ?? .unknown
        
        if let linkStr = try? c.decode(String.self, forKey: .link) {
            self.link = URL(string: linkStr)
        } else {
            self.link = nil
        }
        
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd"
        
        if let openStr = try? c.decode(String.self, forKey: .dateOpen) {
            self.dateOpen = df.date(from: openStr)
        } else { self.dateOpen = nil }
        if let closeStr = try? c.decode(String.self, forKey: .dateClose) {
            self.dateClose = df.date(from: closeStr)
        } else { self.dateClose = nil }
    }
    
    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(name, forKey: .name)
        try c.encode(description, forKey: .description)
        try c.encode(type, forKey: .type)
        if let link { try c.encode(link.absoluteString, forKey: .link) }
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd"
        if let dateOpen { try c.encode(df.string(from: dateOpen), forKey: .dateOpen) }
        if let dateClose { try c.encode(df.string(from: dateClose), forKey: .dateClose) }
    }
}
