//
//  MediaEntityFactoryTests.swift
//  MovieDatabaseTests
//
//  Created by Anthony Glyadchenko on 11/8/22.
//

import XCTest
@testable import MovieDatabase

final class MediaEntityFactoryTests: XCTestCase {
  
  // MARK: - TV show mapping to common MediaEntity
  
  func testMediaEntityFactory_WhenValidTVShowIsProvided_MediaEntityShouldBeCorrect() throws {
    //given
    let dummyFirstAirDate: Date! = DateComponents(calendar: Calendar.init(identifier: .gregorian), timeZone: TimeZone.current, year: 2000, month: 1, day: 1).date
    let dummyFirstAirDateMillisecondsString = String(dummyFirstAirDate.timeIntervalSince1970)
    let dummyTVShowName = "Family Guy"
    let dummyTVShowVoteAverage = 7.1
    let dummyPosterPathURLString = "https://www.google.com/images/logo.png"
    let dummyTVShow = TVShow(id: 1,
                             firstAirDate: dummyFirstAirDateMillisecondsString,
                             name: dummyTVShowName,
                             voteAverage: dummyTVShowVoteAverage,
                             posterPath: dummyPosterPathURLString)
    
    //when
    let mediaEntity = MediaEntityFactory.mediaEntityFromTVShow(dummyTVShow)
    
    //then
    let expectedMediaEntity = MediaEntity(title: "Family Guy", imagePath: URL(string: "https://www.google.com/images/logo.png"), averageRating: "7.1", initialAirDate: "2000-01-01")
    XCTAssertEqual(mediaEntity, expectedMediaEntity)
  }
  
  func testMediaEntityFactory_WhenTVShowIsMissingInitialAirDate_MediaEntityShouldBeNil() throws {
    //given
    let dummyTVShowName = "Family Guy"
    let dummyTVShowVoteAverage = 7.1
    let dummyPosterPathURLString = "https://www.google.com/images/logo.png"
    let dummyTVShow = TVShow(id: 1,
                             firstAirDate: nil,
                             name: dummyTVShowName,
                             voteAverage: dummyTVShowVoteAverage,
                             posterPath: dummyPosterPathURLString)
    
    //when
    let mediaEntity = MediaEntityFactory.mediaEntityFromTVShow(dummyTVShow)
    
    //then
    XCTAssertNil(mediaEntity)
  }
  
  func testMediaEntityFactory_WhenTVShowValidInitialAirDateIsNotISO8601_MediaEntityShouldBeNil() throws {
    //given
    let dummyTVShowName = "Family Guy"
    let dummyTVShowVoteAverage = 7.1
    let dummyPosterPathURLString = "https://www.google.com/images/logo.png"
    let dummyTVShow = TVShow(id: 1,
                             firstAirDate: "1a2b3c",
                             name: dummyTVShowName,
                             voteAverage: dummyTVShowVoteAverage,
                             posterPath: dummyPosterPathURLString)
    
    //when
    let mediaEntity = MediaEntityFactory.mediaEntityFromTVShow(dummyTVShow)
    
    //then
    XCTAssertNil(mediaEntity)
  }
  
  func testMediaEntityFactory_WhenTVShowIsMissingPoster_MediaEntityShouldBeNil() throws {
    //given
    let dummyFirstAirDate: Date! = DateComponents(calendar: Calendar.init(identifier: .gregorian), timeZone: TimeZone.current, year: 2000, month: 1, day: 1).date
    let dummyFirstAirDateMillisecondsString = String(dummyFirstAirDate.timeIntervalSince1970)
    let dummyTVShowName = "Family Guy"
    let dummyTVShowVoteAverage = 7.1
    let dummyTVShow = TVShow(id: 1,
                             firstAirDate: dummyFirstAirDateMillisecondsString,
                             name: dummyTVShowName,
                             voteAverage: dummyTVShowVoteAverage,
                             posterPath: nil)
    
    //when
    let mediaEntity = MediaEntityFactory.mediaEntityFromTVShow(dummyTVShow)
    
    //then
    XCTAssertNil(mediaEntity)
  }
  
  func testMediaEntityFactory_WhenTVShowIsMissingValidPosterUrl_MediaEntityShouldBeNil() throws {
    //given
    let dummyFirstAirDate: Date! = DateComponents(calendar: Calendar.init(identifier: .gregorian), timeZone: TimeZone.current, year: 2000, month: 1, day: 1).date
    let dummyFirstAirDateMillisecondsString = String(dummyFirstAirDate.timeIntervalSince1970)
    let dummyTVShowName = "Family Guy"
    let dummyTVShowVoteAverage = 7.1
    let dummyPosterPathURLString = "["
    let dummyTVShow = TVShow(id: 1,
                             firstAirDate: dummyFirstAirDateMillisecondsString,
                             name: dummyTVShowName,
                             voteAverage: dummyTVShowVoteAverage,
                             posterPath: dummyPosterPathURLString)
    
    //when
    let mediaEntity = MediaEntityFactory.mediaEntityFromTVShow(dummyTVShow)
    
    //then
    XCTAssertNil(mediaEntity)
  }
  
  // MARK: - Movie mapping to common MediaEntity
  
  func testMediaEntityFactory_WhenValidMovieIsProvided_MediaEntityShouldBeCorrect() throws {
    //given
    let dummyFirstAirDate: Date! = DateComponents(calendar: Calendar.init(identifier: .gregorian), timeZone: TimeZone.current, year: 2000, month: 1, day: 1).date
    let dummyFirstAirDateMillisecondsString = String(dummyFirstAirDate.timeIntervalSince1970)
    let dummyMovieName = "Horrible Bosses"
    let dummyMovieVoteAverage = 9.1
    let dummyMoviePosterURLString = "https://www.google.com/images/logo.png"
    let dummyMovie = Movie(id: 1,
                           releaseDate: dummyFirstAirDateMillisecondsString,
                           title: dummyMovieName,
                           voteAverage: dummyMovieVoteAverage,
                           backdropPath: dummyMoviePosterURLString)
    
    //when
    let mediaEntity = MediaEntityFactory.mediaEntityFromMovie(dummyMovie)
    
    //then
    let expectedMediaEntity = MediaEntity(title: "Horrible Bosses", imagePath: URL(string: "https://www.google.com/images/logo.png"), averageRating: "9.1", initialAirDate: "2000-01-01")
    XCTAssertEqual(mediaEntity, expectedMediaEntity)
  }
  
  func testMediaEntityFactory_WhenMoviePosterUrlIsInvalid_MediaEntityShouldBeNil() throws {
    //given
    
    //when
    
    //then
  }
}
