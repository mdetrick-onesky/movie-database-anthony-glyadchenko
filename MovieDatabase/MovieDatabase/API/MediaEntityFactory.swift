import Foundation
import os.log

class MediaEntityFactory {
  private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "MediaEntityMapping")

  private static var dateFormatter: ISO8601DateFormatter = {
    var dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = .withFullDate
    return dateFormatter
  }()
  static func mediaEntityFromTVShow(_ tvShow: TVShow) -> MediaEntity? {
    guard let posterPath = tvShow.posterPath,
          let posterPathUrl = URL(string: posterPath),
          posterPathUrl.scheme != nil,
          posterPathUrl.host != nil
    else {
      logger.debug("TV show poster path not found for show named \(tvShow.name) with id \(tvShow.id)")
      return nil
    }
    
    guard let initialAirDateTimeSinceEpochString = tvShow.firstAirDate,
          let timeIntervalFromEpoch = Double(initialAirDateTimeSinceEpochString)
    else {
      logger.debug("Initial air date not found for show named \(tvShow.name) with id \(tvShow.id)")
      return nil
    }

    let initialAirDate = Date(timeIntervalSince1970: timeIntervalFromEpoch)
    let formattedDateString = dateFormatter.string(from: initialAirDate)
    
    return MediaEntity(title: tvShow.name, imagePath: posterPathUrl, averageRating: String(tvShow.voteAverage), initialAirDate: formattedDateString)
  }
  
  static func mediaEntityFromMovie(_ movie: Movie) -> MediaEntity? {
    guard let backdropPathUrl = URL(string: movie.backdropPath),
          backdropPathUrl.scheme != nil,
          backdropPathUrl.host != nil
    else {
      logger.debug("Movie backdrop path not found for movie named \(movie.title) with id \(movie.id)")
      return nil
    }
    return MediaEntity(title: movie.title, imagePath: backdropPathUrl, averageRating: String(movie.voteAverage), initialAirDate: movie.releaseDate)
  }
}
