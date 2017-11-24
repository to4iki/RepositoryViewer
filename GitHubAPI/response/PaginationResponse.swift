public protocol PaginationResponse {
    associatedtype Element: Decodable 
    var elements: [Element] { get }
    var query: String { get }
    var page: Int { get }
    var nextPage: Int? { get }
    init(elements: [Element], query: String, page: Int, nextPage: Int?)
}

public struct AnyPaginationResponse<Element: Decodable>: PaginationResponse {
    public let elements: [Element]
    public let query: String
    public let page: Int
    public let nextPage: Int?
    
    public init<Response: PaginationResponse>(response: Response) where Response.Element == Element {
        elements = response.elements
        query = response.query
        page = response.page
        nextPage = response.nextPage
    }
    
    public init(elements: [Element], query: String, page: Int, nextPage: Int?) {
        self.elements = elements
        self.query = query
        self.page = page
        self.nextPage = nextPage
    }
}
