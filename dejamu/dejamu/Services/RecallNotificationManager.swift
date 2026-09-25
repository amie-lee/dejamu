//
//  RecallNotificationManager.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import CoreLocation
import Foundation
import Observation
import UserNotifications

@Observable
final class RecallNotificationManager: NSObject, CLLocationManagerDelegate {
    private static let maxMonitoredRegions = 20
    private static let regionRadius: CLLocationDistance = 150

    private let manager = CLLocationManager()
    private var regionInfo: [String: (title: String, artist: String, placeName: String?)] = [:]

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestAuthorization() async -> Bool {
        (try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])) ?? false
    }

    func updateGeofences(for entries: [Entry]) {
        for region in manager.monitoredRegions {
            manager.stopMonitoring(for: region)
        }
        regionInfo.removeAll()

        let candidates = entries.compactMap { entry -> (Entry, CLLocationCoordinate2D)? in
            guard let coordinate = entry.coordinate else { return nil }
            return (entry, coordinate)
        }

        let center = manager.location?.coordinate
        let nearest = candidates
            .sorted { lhs, rhs in
                guard let center else { return false }
                return distance(center, lhs.1) < distance(center, rhs.1)
            }
            .prefix(Self.maxMonitoredRegions)

        for (entry, coordinate) in nearest {
            let identifier = entry.id.uuidString
            let region = CLCircularRegion(center: coordinate, radius: Self.regionRadius, identifier: identifier)
            region.notifyOnEntry = true
            region.notifyOnExit = false
            manager.startMonitoring(for: region)
            regionInfo[identifier] = (entry.title, entry.artist, entry.placeName)
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let info = regionInfo[region.identifier] else { return }

        let content = UNMutableNotificationContent()
        content.title = "You're back where you pinned \(info.title)"
        content.body = info.placeName.map { "\(info.artist) — \($0)" } ?? info.artist
        content.sound = .default

        let request = UNNotificationRequest(identifier: region.identifier, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }

    private func distance(_ a: CLLocationCoordinate2D, _ b: CLLocationCoordinate2D) -> CLLocationDistance {
        CLLocation(latitude: a.latitude, longitude: a.longitude)
            .distance(from: CLLocation(latitude: b.latitude, longitude: b.longitude))
    }
}
