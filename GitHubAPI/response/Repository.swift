public struct Repository: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
    }
    
    public let id: Int
    public let name: String
    public let fullName: String
    public let stargazersCount: Int
}
