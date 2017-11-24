import APIKit
import WebLinking

public protocol PaginationRequest: Request where Response: PaginationResponse {
    var query: String { get }
    var page: Int { get set }
}

extension PaginationRequest {
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        let elements = try JSONDecoder().decode(ResultResponse<Response.Element>.self, from: object as! Data).items
        let nextURIString = urlResponse.findLink(relation: "next")?.uri
        let queryItems = nextURIString.flatMap(URLComponents.init)?.queryItems
        let nextPage = queryItems?
            .filter { $0.name == "page" }
            .flatMap { $0.value }
            .flatMap { Int($0) }
            .first
        
        return Response(elements: elements, query: query, page: page, nextPage: nextPage)
    }
}

private struct ResultResponse<Item: Decodable>: Decodable {
    let items: [Item]
}
