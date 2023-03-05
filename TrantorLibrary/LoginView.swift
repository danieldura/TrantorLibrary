//
//  LoginView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 15/2/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var vm: GeneralViewModel
    
    @State var email = ""
    @State var newUser = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Usuario")
                    .bold()
                    .padding(.horizontal)
                
                HStack {
                    Image(systemName: "envelope")
                    TextField("Enter email address...", text: $email)
                        .textInputAutocapitalization(.never)
                        .background(Color.black.opacity(0.1))
                        .keyboardType(.emailAddress)
                }
                .padding(.horizontal)
            }
            
            VStack {
                Button {
                    if vm.validateEmail(email: email) {
                        Task {
                            if await vm.getUser(email:email) {
                                if vm.userData.role == "usuario" {
                                    vm.screen = .userHome
                                } else {
                                    vm.screen = .adminHome
                                }
                            }
                        }
                    }
                } label: {
                    Text("Log on")
                }
                .buttonStyle(.bordered)
                
                Button {
                    newUser.toggle()
                } label: {
                    Text("No account yet?")
                }
            }
            .padding()
        }
        .frame(height: 400)
        .background(Color.black.opacity(0.2))
        .cornerRadius(20)
        .padding()
        .alert("Invalid User", isPresented: $vm.showAlertLogin) {
            Button("OK", role: .cancel) {}
            .buttonStyle(.bordered)
        } message: {
            Text(vm.errorMsg)
        }
        .sheet(isPresented: $newUser) {
            NewUserView(user: true, locked: false, newUser: $newUser)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(GeneralViewModel())
    }
}
