//
//  SettingsView.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import CoreLocation
import SwiftData
import SwiftUI
import UIKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(PurchaseManager.self) private var purchaseManager

    @State private var locationManager = LocationManager()
    @State private var isPresentingPaywall = false
    @State private var isShowingResetConfirmation = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Location") {
                    HStack {
                        Text("Access")
                        Spacer()
                        Text(locationStatusDescription)
                            .foregroundStyle(.secondary)
                    }
                    if locationManager.authorizationStatus == .denied {
                        Button("Open Settings") {
                            openSystemSettings()
                        }
                    }
                }

                Section("Subscription") {
                    HStack {
                        Text("Dejamu Pro")
                        Spacer()
                        Text(purchaseManager.isPro ? "Active" : "Free")
                            .foregroundStyle(.secondary)
                    }
                    if !purchaseManager.isPro {
                        Button("Upgrade to Pro") {
                            isPresentingPaywall = true
                        }
                    }
                }

                Section("Data") {
                    Button("Reset All Data", role: .destructive) {
                        isShowingResetConfirmation = true
                    }
                }

                Section("About") {
                    Link("Contact", destination: URL(string: "mailto:support@dejamu.app")!)
                    Link("Terms of Service", destination: URL(string: "https://github.com/amie-lee/dejamu")!)
                    Link("Privacy Policy", destination: URL(string: "https://github.com/amie-lee/dejamu")!)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .sheet(isPresented: $isPresentingPaywall) {
                PaywallView()
            }
            .confirmationDialog(
                "Delete all entries? This can't be undone.",
                isPresented: $isShowingResetConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete Everything", role: .destructive) {
                    resetAllData()
                }
            }
        }
    }

    private var locationStatusDescription: String {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            "Allowed"
        case .denied:
            "Denied"
        case .restricted:
            "Restricted"
        case .notDetermined:
            "Not requested"
        @unknown default:
            "Unknown"
        }
    }

    private func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    private func resetAllData() {
        try? modelContext.delete(model: Entry.self)
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: Entry.self, inMemory: true)
}
