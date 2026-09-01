//
//  ShareCardView.swift
//  dejamu
//
//  Created by Seoyoung Lee on 8/18/26.
//

import SwiftUI
import UIKit

struct ShareCardView: View {
    let entry: Entry
    let artworkImage: UIImage?

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            artwork
                .frame(width: 220, height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.2), radius: 8)

            VStack(spacing: 4) {
                Text(entry.title)
                    .font(.title3.bold())
                    .foregroundStyle(.black)
                Text(entry.artist)
                    .font(.subheadline)
                    .foregroundStyle(Color(white: 0.45))
            }

            if !entry.note.isEmpty {
                Text(entry.note)
                    .font(.callout)
                    .foregroundStyle(.black)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .padding(.horizontal, 24)
            }

            VStack(spacing: 2) {
                Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                if let placeName = entry.placeName {
                    Text(placeName)
                }
            }
            .font(.caption)
            .foregroundStyle(Color(white: 0.45))

            Spacer()

            Text("Dejaμ")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Color(white: 0.6))
                .padding(.bottom, 12)
        }
        .padding(24)
        .frame(width: 360, height: 360)
        .background(Color.white)
    }

    @ViewBuilder
    private var artwork: some View {
        if let artworkImage {
            Image(uiImage: artworkImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            Color(white: 0.9)
        }
    }
}

#Preview {
    ShareCardView(
        entry: Entry(
            note: "Preview entry",
            trackId: 0,
            title: "Song",
            artist: "Artist",
            artworkURL: "",
            placeName: "Seoul"
        ),
        artworkImage: nil
    )
}
