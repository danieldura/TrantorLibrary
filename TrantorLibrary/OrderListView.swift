//
//  OrderListView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 25/2/23.
//

import SwiftUI

struct OrderListView: View {
    @EnvironmentObject var vm: GeneralViewModel
    
    let orders: [Order]
    let state: String
    
    @State var title = ""
    
    var body: some View {
            List(orders) { order in
                NavigationLink(value: order) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Order ID:")
                                .font(.caption)
                            Spacer()
                            Text(vm.dateConverse(text: order.date))
                                .font(.caption.bold())
                        }
                        Text(order.id)
                            .font(.caption.bold())
                        
                        Text("User")
                            .font(.caption)
                        Text(order.email)
                            .font(.caption.bold())
                    }
                }
            }
            .navigationTitle(title)
            .navigationDestination(for: Order.self) { order in
                DetailOrderView(order: order)
            }
            .onAppear {
                title = vm.statusConverse(enSp: false, text: (orders.first?.estado ?? ""))
                    .capitalized
            }
    }
}


struct OrderListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OrderListView(orders: [], state: "Recived"/*, screen: .constant(.oders)*/)
                .environmentObject(GeneralViewModel())
        }
    }
}
