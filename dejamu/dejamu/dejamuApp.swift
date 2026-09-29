//
//  dejamuApp.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import SwiftData
import SwiftUI

@main
struct dejamuApp: App {
    private let container: ModelContainer
    @State private var purchaseManager = PurchaseManager()
    @State private var recallNotificationManager = RecallNotificationManager()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    init() {
        container = Entry.makeSharedModelContainer()
        Self.removeDummyEntriesIfPresent(in: container)
    }

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                HomeMapView()
            } else {
                OnboardingView {
                    hasCompletedOnboarding = true
                }
            }
        }
        .modelContainer(container)
        .environment(purchaseManager)
        .environment(recallNotificationManager)
    }

    /// The old dummy-data seed used trackId 1/2/3, which real iTunes tracks never have --
    /// safe to target directly so installs that already seeded these get cleaned up too.
    private static func removeDummyEntriesIfPresent(in container: ModelContainer) {
        let context = container.mainContext
        let dummyTrackIds = [1, 2, 3]
        let predicate = #Predicate<Entry> { dummyTrackIds.contains($0.trackId) }
        guard let dummyEntries = try? context.fetch(FetchDescriptor<Entry>(predicate: predicate)) else { return }
        dummyEntries.forEach { context.delete($0) }
    }
}
