//
//  EntryDetailView.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import SwiftData
import SwiftUI

struct EntryDetailView: View {
    let entry: Entry

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var audioPlayer = AudioPlayer()
    @State private var isEditing = false
    @State private var isShowingDeleteConfirmation = false

    private var isPlaying: Bool {
        audioPlayer.playingTrackId == entry.trackId
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    AsyncImage(url: URL(string: entry.largeArtworkURL)) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.secondary.opacity(0.2)
                    }
                    .frame(width: 240, height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .clipped()
                    .shadow(radius: 6)

                    VStack(spacing: 4) {
                        Text(entry.title).font(.title2.bold())
                        Text(entry.artist).foregroundStyle(.secondary)
                    }

                    if !entry.note.isEmpty {
                        Text(entry.note)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    VStack(spacing: 4) {
                        Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                        if let placeName = entry.placeName {
                            Text(placeName)
                        }
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                    HStack(spacing: 24) {
                        if entry.previewURL != nil {
                            Button(action: togglePreview) {
                                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.system(size: 44))
                            }
                        }

                        if let appleMusicURL = entry.appleMusicURL, let url = URL(string: appleMusicURL) {
                            Link("Open in Apple Music", destination: url)
                        }
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button("Edit", systemImage: "pencil") { isEditing = true }
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            isShowingDeleteConfirmation = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $isEditing) {
                EditEntrySheet(entry: entry)
            }
            .confirmationDialog("Delete this entry?", isPresented: $isShowingDeleteConfirmation, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    modelContext.delete(entry)
                    dismiss()
                }
            }
            .onDisappear {
                audioPlayer.stop()
            }
        }
    }

    private func togglePreview() {
        guard let previewURL = entry.previewURL, let url = URL(string: previewURL) else { return }
        audioPlayer.toggle(trackId: entry.trackId, url: url)
    }
}

#Preview {
    EntryDetailView(
        entry: Entry(
            note: "Preview entry",
            trackId: 0,
            title: "Song",
            artist: "Artist",
            artworkURL: ""
        )
    )
    .modelContainer(for: Entry.self, inMemory: true)
}
