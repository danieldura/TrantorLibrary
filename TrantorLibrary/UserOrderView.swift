//
//  UserOrderView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 3/3/23.
//

import SwiftUI

struct UserOrderView: View {
    @EnvironmentObject var vm: GeneralViewModel
    let option: Options
    @State var state:Status = .recived
    @State var status = ""
    
    var body: some View {
        VStack (alignment: .leading) {
            Picker("State seleccion", selection: $state) {
                ForEach(Status.allCases, id:\.self) { cases in
                    Text(vm.statusConverse(enSp: false, text: cases.rawValue).capitalized)
                }
            }
            .pickerStyle(.menu)
            
            List(vm.ordersByState[state.rawValue] ?? []) { order in
                OrderRowView(order: order)
            }
        }
        .navigationTitle(vm.statusConverse(enSp: false, text: state.rawValue).capitalized)
        .refreshable {
            Task {
                await vm.userOrders()
            }
        }
    }
}

struct UserOrderView_Previews: PreviewProvider {
    static var vm = GeneralViewModel()
    static var previews: some View {
        UserOrderView(option: .orders)
            .environmentObject(vm)
    }
}
