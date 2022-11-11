import Foundation

protocol MovieDatabaseApiDataProvider {
  func movies(searchTerms: String, completion: @escaping (MovieResults?) -> Void)
  func tvShows(searchTerms: String, completion: @escaping (TVShowResults?) -> Void)
  func people(searchTerms: String, completion: @escaping (PersonResults?) -> Void)
}

final class TMDBMovieDatabaseApiDataProvider: MovieDatabaseApiDataProvider {
  private lazy var session = URLSession.shared
  
  private func requestMediaKindEndpoint<T: Decodable>(_ mediaKindEndpoint: TMDBServiceApi.Endpoint, searchTerms: String, decodeTo type: T.Type, completion: @escaping (T?) -> Void) {
    let request = TMDBServiceApi.request(endpoint: mediaKindEndpoint, searchTerms: searchTerms)
    session.dataTask(with: request) { data, response, _ in
      guard let data = data,
            (200...299).contains((response as! HTTPURLResponse).statusCode) else {
        completion(nil)
        return
      }
      
      do {
        completion(try JSONDecoder().decode(type, from: data))
      } catch {
        completion(nil)
      }
    }.resume()
  }

  func movies(searchTerms: String, completion: @escaping (MovieResults?) -> Void) {
    requestMediaKindEndpoint(.movie, searchTerms: searchTerms, decodeTo: MovieResults.self, completion: completion)
  }
  
  func tvShows(searchTerms: String, completion: @escaping (TVShowResults?) -> Void) {
    requestMediaKindEndpoint(.tv, searchTerms: searchTerms, decodeTo: TVShowResults.self, completion: completion)
  }
  
  func people(searchTerms: String, completion: @escaping (PersonResults?) -> Void) {
    requestMediaKindEndpoint(.person, searchTerms: searchTerms, decodeTo: PersonResults.self, completion: completion)
  }
}

protocol MovieDatabaseDataProvider {
  func retrieveMediaDataWithSearchTerms(searchTerms: String, completion: (MovieResults?, TVShowResults?, PersonResults?) -> Void)
}

final class TMDBMovieDatabaseDataProvider: MovieDatabaseDataProvider {
  func retrieveMediaDataWithSearchTerms(searchTerms: String, completion: (MovieResults?, TVShowResults?, PersonResults?) -> Void) {
    let movieDatabaseApiProvider = TMDBMovieDatabaseApiDataProvider()
    var moviesData: MovieResults?
    var tvShowData: TVShowResults?
    var personData: PersonResults?
    
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    movieDatabaseApiProvider.movies(searchTerms: searchTerms) { results in
      moviesData = results
      dispatchGroup.leave()
    }
    
    dispatchGroup.enter()
    movieDatabaseApiProvider.tvShows(searchTerms: searchTerms) { results in
      tvShowData = results
      dispatchGroup.leave()
    }
    
    dispatchGroup.enter()
    movieDatabaseApiProvider.people(searchTerms: searchTerms) { results in
      personData = results
      dispatchGroup.leave()
    }
    
    dispatchGroup.wait()
    
    completion(moviesData, tvShowData, personData)
  }
}
