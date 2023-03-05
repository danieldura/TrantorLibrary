//
//  AdminView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 21/2/23.
//

import SwiftUI

struct AdminView: View {
    @EnvironmentObject var vm: GeneralViewModel
    @State var newUser = false
    
    var body: some View {
        TabView {
            OrdersView()
                .tabItem {
                    Label("Orders", systemImage: "box.truck")
                }
                .tag(0)
            
            NewUserView(user: false,locked: false ,newUser: $newUser)
                .tabItem {
                    Label("New User", systemImage: "person")
                }
                .tag(1)
        }
        .task {
            await (vm.allUserOrders(), vm.getBooks(), vm.getAuthors())
        }
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
            .environmentObject(GeneralViewModel())
    }
}
