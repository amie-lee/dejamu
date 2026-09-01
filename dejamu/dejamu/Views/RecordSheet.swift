//
//  RecordSheet.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import SwiftData
import SwiftUI

struct RecordSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title = ""
    @State private var artist = ""
    @State private var note = ""
    @State private var date = Date.now
    @State private var isLocationOn = true

    private static let noteLimit = 140
    private static let placeholderLatitude = 37.5665
    private static let placeholderLongitude = 126.9780

    var body: some View {
        NavigationStack {
            Form {
                Section("Song") {
                    TextField("Title", text: $title)
                    TextField("Artist", text: $artist)
                }

                Section("Note") {
                    TextField("What were you doing?", text: $note, axis: .vertical)
                        .onChange(of: note) { _, newValue in
                            if newValue.count > Self.noteLimit {
                                note = String(newValue.prefix(Self.noteLimit))
                            }
                        }
                    Text("\(note.count)/\(Self.noteLimit)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    Toggle("Attach location", isOn: $isLocationOn)
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .disabled(title.isEmpty || artist.isEmpty)
                }
            }
        }
    }

    private func save() {
        let entry = Entry(
            date: date,
            note: note,
            trackId: 0,
            title: title,
            artist: artist,
            artworkURL: "",
            latitude: isLocationOn ? Self.placeholderLatitude : nil,
            longitude: isLocationOn ? Self.placeholderLongitude : nil,
            placeName: isLocationOn ? "Seoul" : nil
        )
        modelContext.insert(entry)
        dismiss()
    }
}

#Preview {
    RecordSheet()
        .modelContainer(for: Entry.self, inMemory: true)
}
