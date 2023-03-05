//
//  RatingView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 28/2/23.
//

import SwiftUI

struct RatingView: View {
    let rating: Double
    let size: CGFloat
    
    var body: some View {
        HStack {
            ForEach(1..<6) { index in
                if rating >= Double(index) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: size))
                } else if rating >= Double(index) - 0.5 {
                    Image(systemName: "star.leadinghalf.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: size))
                } else {
                    Image(systemName: "star")
                        .foregroundColor(.yellow)
                        .font(.system(size: size))
                }
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: 4, size: 10)
    }
}
