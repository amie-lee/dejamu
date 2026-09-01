//
//  HomeBottomSheetView.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import SwiftData
import SwiftUI

struct HomeBottomSheetView: View {
    let selectedDetent: PresentationDetent
    let onSelectEntry: (Entry) -> Void
    let onAddEntry: () -> Void

    @State private var mode: Mode = .list

    private enum Mode: String, CaseIterable {
        case list = "List"
        case calendar = "Calendar"
    }

    var body: some View {
        VStack(spacing: 0) {
            if selectedDetent == .height(180) {
                WeeklyStripView(onSelectEntry: onSelectEntry, onAddEntry: onAddEntry)
            } else {
                Picker("View", selection: $mode) {
                    ForEach(Mode.allCases, id: \.self) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom)

                switch mode {
                case .list:
                    EntryListView(onSelectEntry: onSelectEntry)
                case .calendar:
                    EntryCalendarView(onSelectEntry: onSelectEntry)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    HomeBottomSheetView(selectedDetent: .height(180), onSelectEntry: { _ in }, onAddEntry: {})
        .modelContainer(for: Entry.self, inMemory: true)
}
