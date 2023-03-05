//
//  CartView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 19/2/23.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var vm: GeneralViewModel
    
    @State var order = false
    
    var body: some View {
        VStack {
            if vm.cart.isEmpty {
                VStack {
                    Text("Basket is empty")
                        .font(.title.bold())
                    Text("Add a book to your basket")
                }
            } else {
                List(vm.booksId(ids: vm.cart)) { book in
                    HStack {
                        CoverView(url: book.cover)
                            .frame(width: 80, height: 100)
                        VStack {
                            Text(book.title)
                                .bold()
                                .lineLimit(1)
                            Text(vm.authors[book.author] ?? "Not Available")
                            VStack(alignment: .trailing) {
                                Text("Price: \(vm.doubleConvert(book.price, decimal: 2))€")
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            vm.removeFromCart(book: book.id)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
                
                Button {
                    order.toggle()
                } label: {
                    Label("Process order \(vm.doubleConvert(vm.cartPrice(), decimal: 2))€", systemImage: "creditcard")
                        .font(.title3.bold())
                }
                .buttonStyle(.bordered)
                .disabled(vm.cart.count == 0)
                .padding()
            }
        }
        .alert("Order Confirmation", isPresented: $order) {
            HStack {
                Button("Yes") {
                    Task {
                        print (await vm.newOrder())
                            vm.cart.removeAll()
                            await vm.userOrders()
                    }
                }
                Button("Cancel", role: .cancel, action: {})
            }
        } message: {
            Text("Are you sure you want to order?")
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
            .environmentObject(GeneralViewModel())
    }
}
