//
//  EntryPinView.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import SwiftUI

struct EntryPinView: View {
    let entry: Entry

    var body: some View {
        AsyncImage(url: URL(string: entry.artworkURL)) { image in
            image.resizable()
        } placeholder: {
            Color.secondary.opacity(0.2)
        }
        .frame(width: 40, height: 40)
        .clipShape(Circle())
        .overlay(Circle().stroke(.white, lineWidth: 2))
        .shadow(radius: 3)
    }
}

#Preview {
    EntryPinView(
        entry: Entry(
            note: "Preview entry",
            trackId: 0,
            title: "Song",
            artist: "Artist",
            artworkURL: ""
        )
    )
}
