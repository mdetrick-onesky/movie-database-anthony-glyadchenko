import Foundation

public class MovieDatabaseViewModel {
  private let movieDatabaseDataProvider: MovieDatabaseDataProvider
  
  init(movieDatabaseDataProvider: MovieDatabaseDataProvider = TMDBMovieDatabaseDataProvider()) {
    self.movieDatabaseDataProvider = movieDatabaseDataProvider
  }

  func retrieveMediaResults(searchTerms: String, completion: @escaping ([TVShow], [Movie], [Person]) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async {
      self.movieDatabaseDataProvider.retrieveMediaDataWithSearchTerms(searchTerms: searchTerms) { movieResults, tvShowResults, personResults in
        let movieData = movieResults?.results ?? []
        let tvShowData = tvShowResults?.results ?? []
        let personData = personResults?.results ?? []
        completion(tvShowData, movieData, personData)
      }
    }
  }
}
