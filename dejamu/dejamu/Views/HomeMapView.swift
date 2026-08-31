//
//  HomeMapView.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import MapKit
import SwiftData
import SwiftUI

struct HomeMapView: View {
    @Query private var entries: [Entry]
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        Map(position: $position) {
            ForEach(pinnedEntries, id: \.entry.id) { pinned in
                Annotation(pinned.entry.title, coordinate: pinned.coordinate) {
                    EntryPinView(entry: pinned.entry)
                }
            }
        }
    }

    private var pinnedEntries: [(entry: Entry, coordinate: CLLocationCoordinate2D)] {
        entries.compactMap { entry in
            guard let coordinate = entry.coordinate else { return nil }
            return (entry, coordinate)
        }
    }
}

#Preview {
    HomeMapView()
        .modelContainer(for: Entry.self, inMemory: true)
}
