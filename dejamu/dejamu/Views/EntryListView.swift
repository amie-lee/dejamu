//
//  EntryListView.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import SwiftData
import SwiftUI

struct EntryListView: View {
    let onSelectEntry: (Entry) -> Void

    @Query(sort: \Entry.date, order: .reverse) private var entries: [Entry]

    var body: some View {
        List(entries) { entry in
            Button {
                onSelectEntry(entry)
            } label: {
                EntryRow(entry: entry)
            }
            .buttonStyle(.plain)
        }
        .listStyle(.plain)
    }
}

private struct EntryRow: View {
    let entry: Entry

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: entry.artworkURL)) { image in
                image.resizable()
            } placeholder: {
                Color.secondary.opacity(0.2)
            }
            .frame(width: 48, height: 48)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.title).lineLimit(1)
                Text(entry.artist)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .foregroundStyle(.primary)
    }
}

#Preview {
    EntryListView(onSelectEntry: { _ in })
        .modelContainer(for: Entry.self, inMemory: true)
}
