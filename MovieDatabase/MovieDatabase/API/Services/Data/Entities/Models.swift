import Foundation

public struct MovieResults: Codable {
  public let results: [Movie]
}

public struct TVShowResults: Codable {
  public let results: [TVShow]
}

public struct PersonResults: Codable {
  public let results: [Person]
}

public struct Movie: Codable {
  public let id: Int
  public let releaseDate: String
  public let title: String
  public let voteAverage: Double
  public let backdropPath: String

  enum CodingKeys: String, CodingKey {
    case id
    case releaseDate = "release_date"
    case title
    case voteAverage = "vote_average"
    case backdropPath = "backdrop_path"
  }
}

public struct TVShow: Codable {
  public let id: Int
  public let firstAirDate: String?
  public let name: String
  public let voteAverage: Double
  public let posterPath: String?

  enum CodingKeys: String, CodingKey {
    case id
    case firstAirDate = "first_air_date"
    case name
    case voteAverage = "vote_average"
    case posterPath = "poster_path"
  }
}

public struct Person: Codable {

  public struct KnownFor: Codable {
    let id: Int
    let title: String?
    let releaseDate: String?
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
      case id
      case title = "original_title"
      case releaseDate = "release_date"
      case voteAverage = "vote_average"
    }
  }

  public let id: Int
  public let name: String
  public let profilePath: String?
  public let knownFor: [KnownFor]

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case profilePath = "profile_path"
    case knownFor = "known_for"
  }
}

// MARK: - Project specific models

extension Person {
  public var voteAverage: Double {
    let ratingAverage = ratingAverages.values.reduce(0, +) / Double(knownFor.count)
    return ratingAverage
  }
  
  public var ratingAverages: [String : Double] {
    var averages: [String: Double] = [:]
    knownFor.forEach { knownForValue in
      averages[knownForValue.title ?? "Untitled"] = knownForValue.voteAverage
    }
    
    return averages
  }
}

protocol HasVoteAverage {
  var voteAverage: Double { get }
}

extension Movie: HasVoteAverage {}
extension TVShow: HasVoteAverage {}
extension Person: HasVoteAverage {}
