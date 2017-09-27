import APIKit

public final class GitHubAPI {
    public struct SearchRepositoriesRequest: GitHubRequest {
        let query: String
        
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
        
        public init(query: String) {
            self.query = query
        }
    }
}
