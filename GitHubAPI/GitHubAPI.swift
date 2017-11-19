import APIKit

public final class GitHubAPI {
    public struct SearchRepositoriesRequest: GitHubRequest, SearchRequest {
        public let query: String
        public var page: Int
        
        public init(query: String, page: Int = 1) {
            self.query = query
            self.page = page
        }
        
        public typealias Response = SearchResponse<Repository>
        
        public var method: HTTPMethod {
            return .get
        }
        
        public var path: String {
            return "/search/repositories"
        }
        
        public var parameters: Any? {
            return ["q": query]
        }
    }
}
