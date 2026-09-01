//
//  Entry.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import CoreLocation
import Foundation
import SwiftData

@Model
final class Entry {
    var id: UUID
    var createdAt: Date
    var date: Date
    var note: String

    var trackId: Int
    var title: String
    var artist: String
    var artworkURL: String
    var previewURL: String?
    var appleMusicURL: String?

    var latitude: Double?
    var longitude: Double?
    var placeName: String?

    init(
        date: Date = .now,
        note: String,
        trackId: Int,
        title: String,
        artist: String,
        artworkURL: String,
        previewURL: String? = nil,
        appleMusicURL: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        placeName: String? = nil
    ) {
        self.id = UUID()
        self.createdAt = .now
        self.date = date
        self.note = note
        self.trackId = trackId
        self.title = title
        self.artist = artist
        self.artworkURL = artworkURL
        self.previewURL = previewURL
        self.appleMusicURL = appleMusicURL
        self.latitude = latitude
        self.longitude = longitude
        self.placeName = placeName
    }
}

extension Entry {
    var coordinate: CLLocationCoordinate2D? {
        guard let latitude, let longitude else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var largeArtworkURL: String {
        artworkURL.replacingOccurrences(of: "100x100bb.jpg", with: "600x600bb.jpg")
    }
}

extension Entry: Identifiable {}
