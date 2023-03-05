//
//  BookRowView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 28/2/23.
//

import SwiftUI

struct BookRowView: View {
    @EnvironmentObject var vm: GeneralViewModel
    let book: Book
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 90, height: 130)
                    .foregroundColor(.black)
                    .overlay {
                        CoverView(url: book.cover)
                    }
                    .padding(.leading)
                
                VStack {
                    Text(book.title)
                        .font(.callout.bold())
                        .foregroundColor(.black)
                        .lineLimit(2)
                    Text(vm.authors[book.author] ?? "Not Available")
                        .font(.caption.bold())
                        .foregroundColor(.black)
                    RatingView(rating: book.rating ?? 0, size: 10)
                    
                    HStack {
                        Text("\(book.price.description)€")
                            .font(.title3.bold())
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button {
                            vm.addToCart(book: book.id)
                        } label: {
                            Label("Buy", systemImage: "cart")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.yellow)
                        .foregroundColor(.black)
                        
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
            
            if vm.isReaded(id: book.id) {
                Image(systemName: "bookmark.fill")
                    .resizable()
                    .frame(width: 20, height: 30)
                    .foregroundColor(.red)
            }
        }
        .frame(width: 350, height: 150)
    }
}

struct BookRowView_Previews: PreviewProvider {
    static var previews: some View {
        BookRowView(book: .test)
            .environmentObject(GeneralViewModel())
    }
}
