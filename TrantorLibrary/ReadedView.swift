//
//  ReadedView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 3/3/23.
//

import SwiftUI

struct ReadedView: View {
    @EnvironmentObject var vm: GeneralViewModel
    
    let option: Options
    
    var body: some View {
        if vm.readed.isEmpty {
            VStack {
                Text("No books read")
                    .font(.title.bold())
                Text("Swipe left over a book to add")
            }
            .navigationTitle(option.rawValue)
        } else {
            List(vm.booksId(ids: vm.readed)) { book in
                HStack {
                    CoverView(url: book.cover)
                        .frame(width: 100, height: 150)
                    VStack(alignment:.center) {
                        Text(book.title)
                            .bold()
                        Text(vm.authors[book.author] ?? "")
                    }
                }
            }
            .navigationTitle(option.rawValue)
            .refreshable {
                await vm.getReaded(email: vm.userData.email)
            }
        }
    }
}

struct ReadedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ReadedView(option: .readed)
                .environmentObject(GeneralViewModel())
        }
    }
}
