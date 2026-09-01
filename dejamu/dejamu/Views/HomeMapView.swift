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
    @State private var isPresentingRecordSheet = false
    @State private var selectedEntry: Entry?

    var body: some View {
        Map(position: $position) {
            ForEach(pinnedEntries, id: \.entry.id) { pinned in
                Annotation(pinned.entry.title, coordinate: pinned.coordinate) {
                    EntryPinView(entry: pinned.entry)
                        .onTapGesture {
                            selectedEntry = pinned.entry
                        }
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                isPresentingRecordSheet = true
            } label: {
                Image(systemName: "plus")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(.tint, in: Circle())
                    .shadow(radius: 4)
            }
            .padding()
        }
        .sheet(isPresented: $isPresentingRecordSheet) {
            RecordSheet()
        }
        .sheet(item: $selectedEntry) { entry in
            EntryDetailView(entry: entry)
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
