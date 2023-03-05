//
//  SortCatalogueView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 1/3/23.
//

import SwiftUI

struct SortCatalogueView: View {
    @EnvironmentObject var vm: GeneralViewModel
    
    let category: Categories
    @State var books: [Book] = []
    
    var body: some View {
        if category == .byAuthor {
            List {
                ForEach(vm.sortBooksAuthor, id:\.self) { books in
                    Section() {
                        ForEach(books) { book in
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
                        }
                    } header: {
                        Text(vm.authors[books.first?.author ?? ""] ?? "")
                    }
                }
            }
            .navigationDestination(for: Book.self) { book in
                DetailView(book: book)
            }
            .navigationTitle(category.rawValue)
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                Task {
                    try await vm.persistence.getBooks()
                }
            }
        }else {
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
            }
            .navigationDestination(for: Book.self) { book in
                DetailView(book: book)
            }
            .navigationTitle(category.rawValue)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if category == .byPrice {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button {
                                vm.sortPrice = .ascending
                                books = vm.sortedBooks
                            } label: {
                                Label("Less expensive", systemImage: "arrow.up")
                            }
                            
                            Button {
                                vm.sortPrice = .descending
                                books = vm.sortedBooks
                            } label: {
                                Label("More expensive", systemImage: "arrow.down")
                            }
                        } label: {
                            Label("", systemImage: "arrow.up.arrow.down")
                        }
                    }
                }
            }
            .searchable(text: $vm.search)
            .onAppear {
                vm.category = category
                books = vm.sortedBooks
            }
            .onChange(of: vm.search) { newValue in
                if newValue == "" {
                    books = vm.sortedBooks
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

struct SortCatalogueView_Previews: PreviewProvider {
    static var previews: some View {
        SortCatalogueView(category: .topRated)
            .environmentObject(GeneralViewModel())
    }
}
