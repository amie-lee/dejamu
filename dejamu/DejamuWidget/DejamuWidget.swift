//
//  DejamuWidget.swift
//  DejamuWidget
//
//  Created by Seoyoung Lee on 9/25/26.
//

import SwiftData
import SwiftUI
import UIKit
import WidgetKit

/// `TimelineProvider` declares its own `associatedtype Entry`, which shadows
/// the SwiftData model of the same name inside `Provider`'s methods below.
private typealias DejamuEntry = Entry

struct DejamuWidgetEntry: TimelineEntry {
    let date: Date
    let title: String?
    let artist: String?
    let placeName: String?
    let artworkImage: UIImage?
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DejamuWidgetEntry {
        DejamuWidgetEntry(date: .now, title: "Dynamite", artist: "BTS", placeName: "Hongdae", artworkImage: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (DejamuWidgetEntry) -> Void) {
        Task {
            completion(await makeEntry())
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DejamuWidgetEntry>) -> Void) {
        Task {
            let entry = await makeEntry()
            let nextRefresh = Calendar.current.date(byAdding: .hour, value: 6, to: .now) ?? .now.addingTimeInterval(21600)
            completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
        }
    }

    private func makeEntry() async -> DejamuWidgetEntry {
        let container = DejamuEntry.makeSharedModelContainer()
        let context = ModelContext(container)
        let allEntries = (try? context.fetch(FetchDescriptor<DejamuEntry>())) ?? []

        let calendar = Calendar.current
        let selected = allEntries.first { calendar.isDateInToday($0.date) } ?? allEntries.randomElement()

        guard let selected else {
            return DejamuWidgetEntry(date: .now, title: nil, artist: nil, placeName: nil, artworkImage: nil)
        }

        var artworkImage: UIImage?
        if let url = URL(string: selected.artworkURL), let (data, _) = try? await URLSession.shared.data(from: url) {
            artworkImage = UIImage(data: data)
        }

        return DejamuWidgetEntry(
            date: .now,
            title: selected.title,
            artist: selected.artist,
            placeName: selected.placeName,
            artworkImage: artworkImage
        )
    }
}

struct DejamuWidgetEntryView: View {
    let entry: DejamuWidgetEntry

    var body: some View {
        ZStack {
            if let artworkImage = entry.artworkImage {
                Image(uiImage: artworkImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.secondary.opacity(0.2)
            }

            LinearGradient(colors: [.clear, .black.opacity(0.75)], startPoint: .center, endPoint: .bottom)

            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        if let title = entry.title {
                            Text(title)
                                .font(.headline)
                                .foregroundStyle(.white)
                                .lineLimit(1)
                            Text(entry.artist ?? "")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.8))
                                .lineLimit(1)
                        } else {
                            Text("No entries yet")
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                    }
                    Spacer()
                }
            }
            .padding(12)
        }
    }
}

struct DejamuWidget: Widget {
    let kind: String = "DejamuWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DejamuWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Dejamu")
        .description("See today's song, or revisit a memory.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    DejamuWidget()
} timeline: {
    DejamuWidgetEntry(date: .now, title: "Dynamite", artist: "BTS", placeName: "Hongdae", artworkImage: nil)
}
