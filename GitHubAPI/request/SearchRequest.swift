public protocol SearchRequest: PaginationRequest {
    init(query: String, page: Int)
}
