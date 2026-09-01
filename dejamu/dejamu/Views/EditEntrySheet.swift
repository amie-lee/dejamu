//
//  EditEntrySheet.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import SwiftUI

struct EditEntrySheet: View {
    @Bindable var entry: Entry

    @Environment(\.dismiss) private var dismiss

    private static let noteLimit = 140

    var body: some View {
        NavigationStack {
            Form {
                Section("Note") {
                    TextField("What were you doing?", text: $entry.note, axis: .vertical)
                        .onChange(of: entry.note) { _, newValue in
                            if newValue.count > Self.noteLimit {
                                entry.note = String(newValue.prefix(Self.noteLimit))
                            }
                        }
                    Text("\(entry.note.count)/\(Self.noteLimit)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section {
                    DatePicker("Date", selection: $entry.date, displayedComponents: .date)
                }
            }
            .navigationTitle("Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    EditEntrySheet(
        entry: Entry(
            note: "Preview entry",
            trackId: 0,
            title: "Song",
            artist: "Artist",
            artworkURL: ""
        )
    )
}
