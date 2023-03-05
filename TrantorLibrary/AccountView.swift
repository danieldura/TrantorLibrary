//
//  AccountView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 17/2/23.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var vm: GeneralViewModel
    
    let options = [
        Option(name: "Readed books", image: "book", option: .readed),
        Option(name: "Orders", image: "list.clipboard", option: .orders),
        Option(name: "User data", image: "person", option: .data)
        ]
    
    @State var logout = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Options") {
                    ForEach(options, id: \.self) { option in
                        NavigationLink(value: option) {
                            Label(option.name, systemImage: option.image)
                        }
                    }
                }
                Section {
                    Button(role: .destructive) {
                        logout.toggle()
                    } label: {
                        Label("Logout", systemImage: "power")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Account")
            .navigationDestination(for: Option.self) { option in
                OptionsView(option: option.option)
            }
            .alert("Log Out", isPresented: $logout) {
                Button(role: .destructive) {
                    vm.userData = UserData(name: "", email: "", location: "", role: "")
                    vm.screen = .login
                } label: {
                    Text("Logout")
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

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(GeneralViewModel())
    }
}
