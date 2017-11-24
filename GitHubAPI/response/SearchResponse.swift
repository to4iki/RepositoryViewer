public struct SearchResponse<Element: Codable>: PaginationResponse {
    public let elements: [Element]
    public let query: String
    public let page: Int
    public let nextPage: Int?
    
    public init(elements: [Element], query: String, page: Int, nextPage: Int?) {
        self.elements = elements
        self.query = query
        self.page = page
        self.nextPage = nextPage
    }
}
