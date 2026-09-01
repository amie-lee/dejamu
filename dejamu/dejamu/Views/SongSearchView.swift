//
//  SongSearchView.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import SwiftUI

struct SongSearchView: View {
    let onSelect: (ITunesTrack) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    @State private var results: [ITunesTrack] = []
    @State private var audioPlayer = AudioPlayer()

    var body: some View {
        NavigationStack {
            List(results) { track in
                SongResultRow(
                    track: track,
                    isPlaying: audioPlayer.playingTrackId == track.trackId,
                    onSelect: {
                        onSelect(track)
                        dismiss()
                    },
                    onTogglePlay: {
                        guard let previewUrl = track.previewUrl, let url = URL(string: previewUrl) else { return }
                        audioPlayer.toggle(trackId: track.trackId, url: url)
                    }
                )
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $query, prompt: "Song or artist")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .task(id: query) {
                await search()
            }
            .onDisappear {
                audioPlayer.stop()
            }
        }
    }

    private func search() async {
        let term = query.trimmingCharacters(in: .whitespaces)
        guard !term.isEmpty else {
            results = []
            return
        }

        try? await Task.sleep(nanoseconds: 300_000_000)
        guard !Task.isCancelled else { return }

        results = (try? await ITunesAPI.search(term: term)) ?? []
    }
}

private struct SongResultRow: View {
    let track: ITunesTrack
    let isPlaying: Bool
    let onSelect: () -> Void
    let onTogglePlay: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: track.artworkUrl100)) { image in
                image.resizable()
            } placeholder: {
                Color.secondary.opacity(0.2)
            }
            .frame(width: 48, height: 48)
            .clipShape(RoundedRectangle(cornerRadius: 6))

            VStack(alignment: .leading) {
                Text(track.trackName).lineLimit(1)
                Text(track.artistName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            if track.previewUrl != nil {
                Button(action: onTogglePlay) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title2)
                }
                .buttonStyle(.plain)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onSelect)
    }
}

#Preview {
    SongSearchView { _ in }
}
