//
//  ContentView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 15/2/23.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var vm: GeneralViewModel
    
    var body: some View {
        TabView {
            HomeUserView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            CatalogueView()
                .tabItem {
                    Label("Catalogue", systemImage: "books.vertical")
                }
                .tag(1)
            
            CartView()
                .badge(vm.cart.count)
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
                .tag(2)
            
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person")
                }
                .tag(3)
        }
        .task {
            _ = await (vm.userOrders(),
                vm.getReaded(email: vm.userData.email))
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
            .environmentObject(GeneralViewModel())
    }
}
