//
//  WeeklyStripView.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import SwiftData
import SwiftUI

struct WeeklyStripView: View {
    let onSelectEntry: (Entry) -> Void
    let onAddEntry: () -> Void

    @Query(sort: \Entry.date, order: .reverse) private var entries: [Entry]

    private var weekDates: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let weekday = calendar.component(.weekday, from: today)
        let daysSinceStart = (weekday - calendar.firstWeekday + 7) % 7
        let startOfWeek = calendar.date(byAdding: .day, value: -daysSinceStart, to: today)!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                ForEach(weekDates, id: \.self) { day in
                    DayCell(date: day, entry: entry(on: day)) {
                        if let entry = entry(on: day) {
                            onSelectEntry(entry)
                        }
                    }
                }
            }

            Button(action: onAddEntry) {
                Label("Today's song", systemImage: "plus")
            }
            .buttonStyle(.bordered)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private func entry(on day: Date) -> Entry? {
        let calendar = Calendar.current
        return entries.first { calendar.isDate($0.date, inSameDayAs: day) }
    }
}

private struct DayCell: View {
    let date: Date
    let entry: Entry?
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 4) {
            Button(action: onTap) {
                Group {
                    if let entry {
                        AsyncImage(url: URL(string: entry.artworkURL)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.secondary.opacity(0.2)
                        }
                    } else {
                        Circle().strokeBorder(.secondary.opacity(0.3), lineWidth: 1)
                    }
                }
                .frame(width: 36, height: 36)
                .clipShape(Circle())
            }
            .disabled(entry == nil)
            .buttonStyle(.plain)

            Text(date.formatted(.dateTime.weekday(.narrow)))
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    WeeklyStripView(onSelectEntry: { _ in }, onAddEntry: {})
        .modelContainer(for: Entry.self, inMemory: true)
}
