public struct SearchResponse<Element: Codable>: PaginationResponse {
    public let elements: [Element]
    public let page: Int
    public let nextPage: Int?
    
    public init(elements: [Element], page: Int, nextPage: Int?) {
        self.elements = elements
        self.page = page
        self.nextPage = nextPage
    }
}
