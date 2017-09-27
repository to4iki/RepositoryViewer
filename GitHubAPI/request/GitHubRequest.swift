import APIKit

public protocol GitHubRequest: Request {}

extension GitHubRequest {
    public var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    public var dataParser: DataParser {
        return JSONDataParser()
    }
    
    public func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard 200..<300 ~= urlResponse.statusCode else {
            throw GitHubError(object: object)
        }   
        return object
    }
}

extension GitHubRequest where Response: Decodable {
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try JSONDecoder().decode(Response.self, from: object as! Data)
    }
}

public struct GitHubError: Error {
    let message: String
    
    init(object: Any) {
        let dictionary = object as? [String: Any]
        message = dictionary?["message"] as? String ?? "Unknown error occurred"
    }
}
