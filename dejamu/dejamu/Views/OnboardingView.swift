//
//  OnboardingView.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import SwiftUI

struct OnboardingView: View {
    let onFinish: () -> Void

    @State private var page = 0
    @State private var locationManager = LocationManager()

    var body: some View {
        TabView(selection: $page) {
            OnboardingPage(
                systemImage: "mappin.and.ellipse",
                title: "Fill your own map with music.",
                subtitle: "Pin a song to the place you heard it, and build a map of your memories over time."
            )
            .tag(0)

            OnboardingPage(
                systemImage: "clock.arrow.circlepath",
                title: "Writing is free. Looking back is a choice.",
                subtitle: "Record as many entries as you want. Come back to them in a list, or unlock the map view anytime."
            )
            .tag(1)

            OnboardingPage(
                systemImage: "location.fill",
                title: "Let's find you on the map.",
                subtitle: "Dejamu uses your location to place pins where your memories happened."
            ) {
                VStack(spacing: 12) {
                    Button("Enable Location") {
                        locationManager.requestLocation { _ in }
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Get Started", action: onFinish)
                        .buttonStyle(.bordered)
                }
            }
            .tag(2)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

private struct OnboardingPage<Actions: View>: View {
    let systemImage: String
    let title: String
    let subtitle: String
    @ViewBuilder var actions: () -> Actions

    init(
        systemImage: String,
        title: String,
        subtitle: String,
        @ViewBuilder actions: @escaping () -> Actions = { EmptyView() }
    ) {
        self.systemImage = systemImage
        self.title = title
        self.subtitle = subtitle
        self.actions = actions
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: systemImage)
                .font(.system(size: 64))
                .foregroundStyle(.tint)

            VStack(spacing: 8) {
                Text(title)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                Text(subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)

            Spacer()

            actions()
                .padding(.bottom, 48)
        }
    }
}

#Preview {
    OnboardingView(onFinish: {})
}
