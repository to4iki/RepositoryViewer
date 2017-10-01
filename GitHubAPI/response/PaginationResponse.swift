public protocol PaginationResponse {
    associatedtype Element: Decodable 
    var elements: [Element] { get }
    var page: Int { get }
    var nextPage: Int? { get }
    init(elements: [Element], page: Int, nextPage: Int?)
}

public struct AnyPaginationResponse<Element: Decodable>: PaginationResponse {
    public let elements: [Element]
    public let page: Int
    public let nextPage: Int?
    
    public init<Response: PaginationResponse>(response: Response) where Response.Element == Element {
        elements = response.elements
        page = response.page
        nextPage = response.nextPage
    }
    
    public init(elements: [Element], page: Int, nextPage: Int?) {
        self.elements = elements
        self.page = page
        self.nextPage = nextPage
    }
}
