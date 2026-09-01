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

    @State private var selectedTrack: ITunesTrack?
    @State private var isPresentingSongSearch = false
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
                    Button {
                        isPresentingSongSearch = true
                    } label: {
                        if let selectedTrack {
                            SelectedSongRow(track: selectedTrack)
                        } else {
                            Text("Choose a song")
                        }
                    }
                    .buttonStyle(.plain)
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
                        .disabled(selectedTrack == nil)
                }
            }
            .sheet(isPresented: $isPresentingSongSearch) {
                SongSearchView { track in
                    selectedTrack = track
                }
            }
        }
    }

    private func save() {
        guard let selectedTrack else { return }

        let entry = Entry(
            date: date,
            note: note,
            trackId: selectedTrack.trackId,
            title: selectedTrack.trackName,
            artist: selectedTrack.artistName,
            artworkURL: selectedTrack.artworkUrl100,
            previewURL: selectedTrack.previewUrl,
            appleMusicURL: selectedTrack.trackViewUrl,
            latitude: isLocationOn ? Self.placeholderLatitude : nil,
            longitude: isLocationOn ? Self.placeholderLongitude : nil,
            placeName: isLocationOn ? "Seoul" : nil
        )
        modelContext.insert(entry)
        dismiss()
    }
}

private struct SelectedSongRow: View {
    let track: ITunesTrack

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: track.artworkUrl100)) { image in
                image.resizable()
            } placeholder: {
                Color.secondary.opacity(0.2)
            }
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 6))

            VStack(alignment: .leading) {
                Text(track.trackName).lineLimit(1)
                Text(track.artistName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .foregroundStyle(.primary)
    }
}

#Preview {
    RecordSheet()
        .modelContainer(for: Entry.self, inMemory: true)
}
