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
    var body: some Scene {
        WindowGroup {
            HomeMapView()
        }
        .modelContainer(for: Entry.self)
    }
}
