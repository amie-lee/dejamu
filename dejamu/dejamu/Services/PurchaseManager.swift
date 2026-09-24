//
//  PurchaseManager.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import Foundation
import Observation
import RevenueCat

@Observable
final class PurchaseManager: NSObject, PurchasesDelegate {
    private static let apiKey = "test_gFtdWFRxNiTkGMymbIFyCcIuPJh"

    private(set) var isPro = false

    override init() {
        super.init()
        Purchases.configure(withAPIKey: Self.apiKey)
        Purchases.shared.delegate = self
        Task { await refresh() }
    }

    func refresh() async {
        guard let customerInfo = try? await Purchases.shared.customerInfo() else { return }
        updateProStatus(from: customerInfo)
    }

    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        updateProStatus(from: customerInfo)
    }

    private func updateProStatus(from customerInfo: CustomerInfo) {
        isPro = customerInfo.entitlements["dejamu_pro"]?.isActive == true
    }
}
