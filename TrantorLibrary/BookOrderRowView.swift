//
//  BookOrderRowView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 22/2/23.
//

import SwiftUI

struct BookOrderRowView: View {
    @EnvironmentObject var vm: GeneralViewModel
    let book: Book
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.callout.bold())
                    .lineLimit(1)
                Text(vm.authors[book.author] ?? "Not Available")
                    .font(.caption)
            }
            
            Spacer()
            
            VStack {
                Text("Price")
                    .font(.caption)
                Text("\(vm.doubleConvert(book.price, decimal: 2))€")
                    .font(.callout)
            }
        }
    }
}

struct BookOrderRowView_Previews: PreviewProvider {
    static var previews: some View {
        BookOrderRowView(book: .test)
            .environmentObject(GeneralViewModel())
    }
}
