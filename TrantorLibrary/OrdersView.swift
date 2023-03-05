//
//  OrdersView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 24/2/23.
//

import SwiftUI

enum AdminScreen {
    case home
    case oders
}

struct OrdersView: View {
    @EnvironmentObject var vm: GeneralViewModel
    
    let columns = [GridItem(.flexible())]
    @State var status = ""
    @State var screen: AdminScreen = .home
    @State var logout = false
    
    var body: some View {
        NavigationStack {
            List(Status.allCases, id: \.self) { state in
                NavigationLink(value: state) {
                    Text(vm.statusConverse(enSp: false, text: state.rawValue).capitalized)
                        .badge(vm.ordersByState[state.rawValue]?.count ?? 0)
                }
            }
            .navigationTitle("Orders")
            .navigationDestination(for: Status.self) { state in
                OrderListView(orders: vm.ordersByState[state.rawValue]?.sorted(by: {$0.date < $1.date}) ?? [], state: state.rawValue)
            }
            .refreshable {
                Task {
                    await vm.allUserOrders()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    Menu {
                        Button {
                            logout.toggle()
                        } label: {
                            Label("Log out", systemImage: "power")
                        }
                    } label: {
                        Label("Add", systemImage: "ellipsis.circle")
                    }
                }
            }
            .alert("Log Out", isPresented: $logout) {
                Button(role: .destructive) {
                    vm.userData = UserData(name: "", email: "", location: "", role: "")
                    vm.screen = .login
                } label: {
                    Text("Done")
                }
                
                Button(role: .cancel) {
                } label: {
                    Text("Cancel")
                }
                
            } message: {
                Text("Are you sure you want to log out?")
            }
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OrdersView()
                .environmentObject(GeneralViewModel())
        }
    }
}
