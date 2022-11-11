import Foundation

protocol TMDBApiKeyProvider {
  var apiKey: String { get }
}

struct TMDBApiExposedApiKeyProvider: TMDBApiKeyProvider {
  var apiKey: String = "c352da303cecea898250194bd5cc0dc5"
}

enum TMDBServiceApi {
  static let baseURL = URL(string: "https://api.themoviedb.org/3")!
  
  enum Endpoint: String {
    case movie = "/search/movie"
    case tv = "/search/tv"
    case person = "/search/person"
  }
  static func request(endpoint: Endpoint, apiKeyProvider: TMDBApiKeyProvider = TMDBApiExposedApiKeyProvider(), searchTerms: String) -> URLRequest {
    let queryItemsFromApiKeyAndSearchTerms: [URLQueryItem] = {
      let apiKeyQueryItem = URLQueryItem(name: "api_key", value: apiKeyProvider.apiKey)
      let searchTermsQueryItem = URLQueryItem(name: "query", value: searchTerms)
      return [apiKeyQueryItem, searchTermsQueryItem]
    }()

    var urlComponents: URLComponents! = URLComponents(url: baseURL.appendingPathComponent(endpoint.rawValue), resolvingAgainstBaseURL: false)
    urlComponents.queryItems = queryItemsFromApiKeyAndSearchTerms
    let url: URL! = urlComponents.url
    return URLRequest(url: url)
  }
}
