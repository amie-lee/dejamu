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
        VStack(spacing: 8) {
            artwork
                .frame(width: 180, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.2), radius: 6)

            VStack(spacing: 2) {
                Text(entry.title)
                    .font(.title3.bold())
                    .foregroundStyle(.black)
                    .lineLimit(1)
                Text(entry.artist)
                    .font(.subheadline)
                    .foregroundStyle(Color(white: 0.45))
                    .lineLimit(1)
            }

            if !entry.note.isEmpty {
                Text(entry.note)
                    .font(.callout)
                    .foregroundStyle(.black)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .padding(.horizontal, 20)
            }

            VStack(spacing: 2) {
                Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                    .lineLimit(1)
                if let placeName = entry.placeName {
                    Text(placeName)
                        .lineLimit(1)
                }
            }
            .font(.caption)
            .foregroundStyle(Color(white: 0.45))

            Spacer(minLength: 0)

            Text("Dejaμ")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Color(white: 0.6))
                .lineLimit(1)
        }
        .padding(16)
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
