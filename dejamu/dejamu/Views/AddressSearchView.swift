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
    @State private var isSearching = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                TextField("Address or place name", text: $query)
                    .submitLabel(.search)
                    .onSubmit(search)

                if let errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Search Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isSearching {
                        ProgressView()
                    } else {
                        Button("Search", action: search)
                            .disabled(query.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
            }
        }
    }

    private func search() {
        let term = query.trimmingCharacters(in: .whitespaces)
        guard !term.isEmpty else { return }

        isSearching = true
        errorMessage = nil

        Task {
            let placemark = try? await CLGeocoder().geocodeAddressString(term).first
            isSearching = false

            guard let location = placemark?.location else {
                errorMessage = "No matching address found."
                return
            }

            onSelect(location.coordinate, placemark?.locality ?? placemark?.name)
            dismiss()
        }
    }
}

#Preview {
    AddressSearchView { _, _ in }
}
