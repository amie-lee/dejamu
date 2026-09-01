//
//  ITunesAPI.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import Foundation

struct ITunesTrack: Codable, Identifiable, Hashable {
    var id: Int { trackId }

    let trackId: Int
    let trackName: String
    let artistName: String
    let artworkUrl100: String
    let previewUrl: String?
    let trackViewUrl: String?
}

private struct ITunesSearchResponse: Codable {
    let results: [ITunesTrack]
}

enum ITunesAPI {
    private static let searchURL = "https://itunes.apple.com/search"

    static func search(term: String) async throws -> [ITunesTrack] {
        var components = URLComponents(string: searchURL)!
        components.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "entity", value: "song"),
            URLQueryItem(name: "limit", value: "25"),
            URLQueryItem(name: "country", value: "KR"),
        ]

        let (data, _) = try await URLSession.shared.data(from: components.url!)
        return try JSONDecoder().decode(ITunesSearchResponse.self, from: data).results
    }
}
