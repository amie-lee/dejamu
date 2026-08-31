//
//  dejamuApp.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import SwiftData
import SwiftUI

@main
struct dejamuApp: App {
    private let container: ModelContainer

    init() {
        container = try! ModelContainer(for: Entry.self)
        Self.seedDummyEntriesIfNeeded(in: container)
    }

    var body: some Scene {
        WindowGroup {
            HomeMapView()
        }
        .modelContainer(container)
    }

    private static func seedDummyEntriesIfNeeded(in container: ModelContainer) {
        let context = container.mainContext
        guard let count = try? context.fetchCount(FetchDescriptor<Entry>()), count == 0 else { return }

        let dummyEntries = [
            Entry(
                note: "Walked past a busker playing this on loop.",
                trackId: 1,
                title: "Dynamite",
                artist: "BTS",
                artworkURL: "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/dynamite/100x100bb.jpg",
                latitude: 37.5563,
                longitude: 126.9236,
                placeName: "Hongdae"
            ),
            Entry(
                note: "Coffee, rain, and this song on repeat.",
                trackId: 2,
                title: "Through the Night",
                artist: "IU",
                artworkURL: "https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/through-the-night/100x100bb.jpg",
                latitude: 37.5446,
                longitude: 127.0557,
                placeName: "Seongsu-dong"
            ),
            Entry(
                note: "Sunset by the river, headphones in.",
                trackId: 3,
                title: "Blueming",
                artist: "IU",
                artworkURL: "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/blueming/100x100bb.jpg",
                latitude: 37.5133,
                longitude: 127.0019,
                placeName: "Banpo Hangang Park"
            ),
        ]

        dummyEntries.forEach { context.insert($0) }
    }
}
