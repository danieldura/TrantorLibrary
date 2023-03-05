//
//  CatalogueView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 18/2/23.
//

import SwiftUI

struct CatalogueView: View {
    @EnvironmentObject var vm: GeneralViewModel
    
    @State var books: [Book] = []
    
    var body: some View {
        NavigationStack {
            List(books) { book in
                NavigationLink(value: book) {
                    BookRowView(book: book)
                        .swipeActions {
                            Button {
                                Task {
                                    if await vm.toggleReaded(readed: ReadedBooks(books: [book.id], email: vm.userData.email)) {
                                        await vm.getReaded(email: vm.userData.email)
                                    }
                                }
                            } label: {
                                if !vm.isReaded(id: book.id) {
                                    Label("Read", systemImage: "bookmark")
                                } else {
                                    Label("Unread", systemImage: "bookmark.slash")
                                }
                            }
                            .tint(vm.isReaded(id: book.id) ? .red : .green)
                        }
                }
                .navigationDestination(for: Book.self) { book in
                    DetailView(book: book)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Catalogue")
            .searchable(text: $vm.search)
            
            .onAppear {
                books = vm.books
            }
            .onChange(of: vm.search) { newValue in
                if newValue == "" {
                    books = vm.books
                } else {
                    Task {
                        do {
                            books = try await vm.persistence.getSearchBook(search: vm.search)
                        } catch {
                            books = []
                        }
                    }
                }
            }
            .refreshable {
                Task {
                    try await vm.persistence.getBooks()
                }
            }
        }
    }
}

struct CatalogueView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CatalogueView()
                .environmentObject(GeneralViewModel())
        }
    }
}
