//
//  AddressSearchView.swift
//  dejamu
//
//  Created by Seoyoung Lee on 9/30/26.
//

import CoreLocation
import SwiftUI

struct AddressSearchView: View {
    let onSelect: (CLLocationCoordinate2D, String?) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    @State private var results: [CLPlacemark] = []
    @State private var hasSearched = false

    var body: some View {
        NavigationStack {
            Group {
                if results.isEmpty && hasSearched {
                    ContentUnavailableView.search(text: query)
                } else {
                    List(Array(results.enumerated()), id: \.offset) { _, placemark in
                        Button {
                            select(placemark)
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(primaryName(for: placemark))
                                if let secondary = secondaryLine(for: placemark) {
                                    Text(secondary)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
            .navigationTitle("Search Address")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $query, prompt: "Address or place name")
            .onSubmit(of: .search, search)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func search() {
        let term = query.trimmingCharacters(in: .whitespaces)
        guard !term.isEmpty else { return }

        Task {
            results = (try? await CLGeocoder().geocodeAddressString(term)) ?? []
            hasSearched = true
        }
    }

    private func select(_ placemark: CLPlacemark) {
        guard let coordinate = placemark.location?.coordinate else { return }
        onSelect(coordinate, primaryName(for: placemark))
        dismiss()
    }

    private func primaryName(for placemark: CLPlacemark) -> String {
        placemark.name ?? placemark.locality ?? query
    }

    private func secondaryLine(for placemark: CLPlacemark) -> String? {
        let primary = primaryName(for: placemark)
        let parts = [placemark.locality, placemark.administrativeArea, placemark.country]
            .compactMap { $0 }
            .filter { $0 != primary }
        return parts.isEmpty ? nil : parts.joined(separator: ", ")
    }
}

#Preview {
    AddressSearchView { _, _ in }
}
