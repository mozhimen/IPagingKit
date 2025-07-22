//
//  ContentViewModel.swift
//  IPagingKit_Example
//
//  Created by Taiyou on 2025/7/21.
//

import SwiftUI
import Foundation
import Combine

// MARK: - AlbumResult
struct AlbumResult: Codable {
    let resultCount: Int
    let results: [Album]
}

// MARK: - Result
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
enum PageState{
    case Loading
    case NoLoading
}

enum LoadState: Comparable {
    case loadStart
    case loadEmpty
    case loading
    case loadFinished(PageState)
    case loadError(String)
        
    case good
    case isLoading
    case loadedAll
    case error(String)
}

class ContentViewModel:ObservableObject{
    
    
    @Published var searchText: String = "rammstein"
    @Published var albums: [Album] = [Album]()
    @Published var loadState: LoadState = .loadStart {
        didSet {
            print("state changed to: \(loadState)")
        }
    }
    
    let limit: Int = 20
    var page: Int = 0
    
    var subscriptions = Set<AnyCancellable>()
    
    //=================================================================>
    
    init() {
        $searchText
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] term in
                self?.loadState = .loadStart
                self?.albums = []
                self?.fetchAlbums(term)
            }.store(in: &subscriptions)
    }
    
    //=================================================================>

    func fetchAlbums(_ searchText: String) {
        
        guard !searchText.isEmpty else {
            return
        }
        
        guard loadState == LoadState.loadStart else {
            return
        }
        
        let offset = page * limit
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchText)&entity=album&limit=\(limit)&offset=\(offset)") else {
            return
        }
        
        
        print("start fetching data for \(searchText)")
        loadState = .isLoading
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("urlsession error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.loadState = .error("Could not load: \(error.localizedDescription)")
                }
            } else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(AlbumResult.self, from: data)
                    DispatchQueue.main.async {
                        for album in result.results {
                            self?.albums.append(album)
                        }
                        self?.page += 1
                        self?.loadState = (result.results.count == self?.limit) ? .good : .loadedAll
                        print("fetched \(result.resultCount)")
                    }
                   
                } catch {
                    print("decoding error \(error)")
                    DispatchQueue.main.async {
                        self?.loadState = .loadError("Could not get data: \(error.localizedDescription)")
                    }
                }
            }
        }.resume()
    }
}
