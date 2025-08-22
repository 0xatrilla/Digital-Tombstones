import Foundation

public enum KilledServiceError: Error, LocalizedError {
    case invalidResponse
    case decodingFailed
    case network(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Invalid response from server"
        case .decodingFailed: return "Failed to decode data"
        case .network(let err): return err.localizedDescription
        }
    }
}

public protocol KilledServiceProtocol: Sendable {
    func fetchItems() async throws -> [KilledItem]
}

public struct KilledService: KilledServiceProtocol {
    public init() {}
    
    // Official data source from the project repository
    private let dataURL = URL(string: "https://raw.githubusercontent.com/codyogden/killedbygoogle/main/graveyard.json")!
    
    public func fetchItems() async throws -> [KilledItem] {
        do {
            let (data, response) = try await URLSession.shared.data(from: dataURL)
            guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
                throw KilledServiceError.invalidResponse
            }
            let decoder = JSONDecoder()
            let items = try decoder.decode([KilledItem].self, from: data)
            return items
        } catch let err as KilledServiceError {
            throw err
        } catch {
            throw KilledServiceError.network(error)
        }
    }
}
