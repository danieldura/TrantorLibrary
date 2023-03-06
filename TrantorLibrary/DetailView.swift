//
//  DetailView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 19/2/23.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var vm: GeneralViewModel
    let book: Book
    
    @State var sumary = false
    @State var plot   = false
    
    var body: some View {
        VStack {
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text(vm.authors[book.author] ?? "Not Available")
                        .font(.title3)
                    Text(book.year.description)
                    
                    // cover and price
                    HStack {
                        VStack {
                            Text("Price")
                            Text("\(vm.doubleConvert(book.price, decimal: 2))€")
                                .font(.title2.bold())
                            
                            Button {
                                vm.addToCart(book: book.id)
                            } label: {
                                Label("Buy", systemImage: "cart")
                                    .bold()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.yellow)
                            .foregroundColor(.black)
                            
                            Button {
                                Task {
                                    if await vm.toggleReaded(readed: ReadedBooks(books: [book.id], email: vm.userData.email)) {
                                        await vm.getReaded(email: vm.userData.email)
                                        
                                    }
                                }
                            } label: {
                                
                                Label(!vm.isReaded(id: book.id) ? "Read" : "Unread", systemImage: !vm.isReaded(id: book.id) ? "bookmark.fill" : "bookmark.slash.fill")
                            }
                            .buttonStyle(.borderedProminent)
                            // .tint(vm.isReaded(id: book.id) ? .green : .red)
                        }
                        Spacer()
                        VStack {
                            CoverView(url: book.cover)
                                .frame(width: 200, height: 300)
                                .shadow(color: .black.opacity(0.8), radius: 10, x: 0, y: 10)                        }
                    }
                    VStack {
                        RatingView(rating: book.rating ?? 0, size: 20)
                            .padding(.top, 10)
                        Text("\(vm.doubleConvert(book.rating ?? 0, decimal: 1))/5.0")
                        Text("Nº Pages: \(book.pages?.description ?? "?")")
                    }
                    .padding(.leading, 180)
                    
                    //isbn
                    HStack {
                        Text("ISBN:")
                            .font(.callout)
                        Text(book.isbn ?? "Not available")
                            .font(.callout)
                    }
                    .padding(.vertical, 5)
                    // summary and plot
                }
                
                VStack(alignment: .center) {
                    Text("Sumary")
                        .font(.title3.bold())
                    Text(book.summary ?? "Not available")
                        .italic()
                        .lineLimit(sumary ? nil : 3)
                    Button(sumary ? "Read less" : "Read more") {
                        sumary.toggle()
                    }
                    .padding(.bottom, 5)
                    Text("Plot")
                        .font(.title3.bold())
                    Text(book.plot ?? "No available")
                        .italic()
                        .lineLimit(plot ? nil : 3)
                    Button(plot ? "Read less" : "Read more") {
                        plot.toggle()
                    }
                }
            }
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.large)
        .padding(.horizontal)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailView(book: .test)
                .environmentObject(GeneralViewModel())
        }
    }
}
