//
//  Apis.swift
//  IPagingKit_Example
//
//  Created by Taiyou on 2025/7/24.
//
import INetKit_Retrofit
final class Apis:Scope<Retroft>{
    struct SearchRequest{
        @Path("searchText") var searchText:String = ""
        @Path("limit") var limit:Int = 0
        @Path("offset") var offset:Int = 0
    }
    
    @GET("/search?term={searchText}&entity=album&limit={limit}&offset={offset}")
    var search: (SearchRequest)  async throws -> SearchRes?
}

//===============================================================================>

struct SearchRes: Codable {
    let resultCount: Int
    let results: [Album]
}

struct Album: Codable, Identifiable {
    let wrapperType, collectionType: String
    let id: Int
    let artistID: Int
    let amgArtistID: Int?
    let artistName, collectionName, collectionCensoredName: String
    let artistViewURL: String?
    let collectionViewURL: String
    let artworkUrl60, artworkUrl100: String
    let collectionPrice: Double?
    let collectionExplicitness: String
    let trackCount: Int
    let copyright: String?
    let country, currency: String
    let releaseDate: String
    let primaryGenreName: String

    enum CodingKeys: String, CodingKey {
        case wrapperType, collectionType
        case artistID = "artistId"
        case id = "collectionId"
        case amgArtistID = "amgArtistId"
        case artistName, collectionName, collectionCensoredName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case artworkUrl60, artworkUrl100, collectionPrice, collectionExplicitness, trackCount, copyright, country, currency, releaseDate, primaryGenreName
    }
}
