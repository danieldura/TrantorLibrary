//
//  CartRowView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 22/2/23.
//

import SwiftUI

struct OrderRowView: View {
    @EnvironmentObject var vm: GeneralViewModel
    
    let order: Order
    var body: some View {
        VStack(alignment: .leading) {
            Text("Order ID:")
                .font(.caption2)
            Text(order.id)
                .font(.caption.bold())
            
            HStack {
                Text("Date:")
                    .font(.caption2)
                Spacer()
                Text("Total:")
                    .font(.caption2)
            }
            
           HStack {
                Text(vm.dateConverse(text: order.date))
                   .font(.caption.bold())
                Spacer()
               Text("\(vm.doubleConvert(vm.orderPrice(books: order.books), decimal: 2))€")
                   .bold()
            }
           .padding(.bottom)

            ForEach(vm.booksId(ids: order.books)) { book in
                VStack {
                    BookOrderRowView(book: book)
                }
            }
        }
    }
}

struct CartRowView_Previews: PreviewProvider {
    static var previews: some View {
        OrderRowView(order: Order(id: "DFA36D29-A866-4176-A74F-92565F0B5BBE", email: "", books: [1,2,3,4], estado: "recibido", date: "2023-02-21T17:52:35Z"))
            .environmentObject(GeneralViewModel())
    }
}
