//
//  EntryCalendarView.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import SwiftData
import SwiftUI

struct EntryCalendarView: View {
    let onSelectEntry: (Entry) -> Void

    @Query(sort: \Entry.date, order: .reverse) private var entries: [Entry]
    @State private var displayedMonth = Date.now

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button {
                    shiftMonth(by: -1)
                } label: {
                    Image(systemName: "chevron.left")
                }

                Spacer()

                Text(displayedMonth.formatted(.dateTime.year().month(.wide)))
                    .font(.headline)

                Spacer()

                Button {
                    shiftMonth(by: 1)
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)

            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(daysInMonth, id: \.self) { day in
                    if let day {
                        DayGridCell(date: day, entry: entry(on: day)) {
                            if let entry = entry(on: day) {
                                onSelectEntry(entry)
                            }
                        }
                    } else {
                        Color.clear
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private var daysInMonth: [Date?] {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
              let firstWeekOfMonth = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start)
        else { return [] }

        let leadingEmptyDays = calendar.dateComponents([.day], from: firstWeekOfMonth.start, to: monthInterval.start).day ?? 0
        var days: [Date?] = Array(repeating: nil, count: leadingEmptyDays)

        var date = monthInterval.start
        while date < monthInterval.end {
            days.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }

        return days
    }

    private func entry(on day: Date) -> Entry? {
        let calendar = Calendar.current
        return entries.first { calendar.isDate($0.date, inSameDayAs: day) }
    }

    private func shiftMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: displayedMonth) {
            displayedMonth = newMonth
        }
    }
}

private struct DayGridCell: View {
    let date: Date
    let entry: Entry?
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topLeading) {
                if let entry {
                    AsyncImage(url: URL(string: entry.artworkURL)) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.secondary.opacity(0.15)
                    }
                } else {
                    Color.secondary.opacity(0.08)
                }

                Text(date.formatted(.dateTime.day()))
                    .font(.caption2.weight(.semibold))
                    .padding(3)
                    .foregroundStyle(entry == nil ? Color.secondary : Color.white)
                    .shadow(radius: entry == nil ? 0 : 2)
            }
            .aspectRatio(1, contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .disabled(entry == nil)
        .buttonStyle(.plain)
    }
}

#Preview {
    EntryCalendarView(onSelectEntry: { _ in })
        .modelContainer(for: Entry.self, inMemory: true)
}
