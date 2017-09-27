public struct SearchResponse<Item: Codable>: Codable {
    private enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
    }
    
    public let items: [Item]
    public let totalCount: Int
}
