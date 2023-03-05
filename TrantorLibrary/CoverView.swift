//
//  CoverView2.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 28/2/23.
//

import SwiftUI

struct CoverView: View {
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let cover):
                cover
                    .resizable()
                    .cornerRadius(20)
            case .failure, .empty:
                RoundedRectangle(cornerRadius: 20)
                    .opacity(0.1)
                    .overlay {
                        Image(systemName: "book")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.black)
                    }
            }
        }
    }
}

struct CoverView2_Previews: PreviewProvider {
    static var previews: some View {
        CoverView(url: URL(string: "https/images.gr-assets.com/books/1327942880l/2493.jpg"))
    }
}
