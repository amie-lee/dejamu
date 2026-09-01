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
    @State private var selectedDetent: PresentationDetent = .height(180)
    @State private var locationManager = LocationManager()

    var body: some View {
        ZStack {
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
            .overlay(alignment: .topTrailing) {
                Button(action: centerOnCurrentLocation) {
                    Image(systemName: "location.fill")
                        .font(.body.weight(.semibold))
                        .frame(width: 40, height: 40)
                        .background(.regularMaterial, in: Circle())
                        .shadow(radius: 2)
                }
                .padding()
            }
            .sheet(isPresented: $isPresentingRecordSheet) {
                RecordSheet()
            }
            .sheet(item: $selectedEntry) { entry in
                EntryDetailView(entry: entry)
            }

            Color.clear
                .allowsHitTesting(false)
                .sheet(isPresented: .constant(true)) {
                    HomeBottomSheetView(
                        selectedDetent: selectedDetent,
                        onSelectEntry: { selectedEntry = $0 },
                        onAddEntry: { isPresentingRecordSheet = true }
                    )
                    .presentationDetents([.height(180), .medium, .large], selection: $selectedDetent)
                    .presentationDragIndicator(.visible)
                    .presentationBackgroundInteraction(.enabled)
                    .interactiveDismissDisabled()
                }
        }
    }

    private var pinnedEntries: [(entry: Entry, coordinate: CLLocationCoordinate2D)] {
        entries.compactMap { entry in
            guard let coordinate = entry.coordinate else { return nil }
            return (entry, coordinate)
        }
    }

    private func centerOnCurrentLocation() {
        locationManager.requestLocation { coordinate in
            guard let coordinate else { return }
            withAnimation {
                position = .region(
                    MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                )
            }
        }
    }
}

#Preview {
    HomeMapView()
        .modelContainer(for: Entry.self, inMemory: true)
}
