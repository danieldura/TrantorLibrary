//
//  NewUserView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 15/2/23.
//

import SwiftUI

struct NewUserView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var vm: GeneralViewModel
    
    let user: Bool
    let locked: Bool
    @Binding var newUser: Bool
    
    
    @State var email = ""
    @State var name = ""
    @State var location = ""
    @State var error = [true, true, true]
    
    @State var alert = false
    @State var userCreated = false
    @State var alertMsg = ""
    
    @State var role: Role = .user
    
    var body: some View {
        VStack {
            Text("Register Data")
                .font(.largeTitle.bold())
                .padding()
            Form {
                FormRowView(error: $error[0], label: "Email", placeholder: "Enter email address", text: $email, validation: vm.validateEmail)
                    .disabled(locked)
                    .autocorrectionDisabled(true)
                
                FormRowView(error:$error[1], label: "Name", placeholder: "Enter your name", text: $name, validation: vm.validateEmpty)
                    .autocorrectionDisabled(true)
                
                FormRowView(error:$error[2], label: "Location", placeholder: "Enter your location", text: $location, validation: vm.validateEmpty)
                    .autocorrectionDisabled(true)
                VStack {
                    Picker("Role", selection: $role) {
                        ForEach(Role.allCases, id:\.self) { cases in
                            Text(cases.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .opacity(user ? 0 : 1)
            }
            
            HStack {
                Button {
                    if locked {
                        dismiss()
                    }
                    newUser.toggle()
                } label: {
                    Text("Cancel")
                }
                .buttonStyle(.bordered)
                
                Button {
                    Task {
                        if await vm.getUser(email: email) && !locked {
                            alert.toggle()
                            alertMsg = "The entered user already exists"
                        } else {
                            if await vm.newUser(user:NewUser(role: vm.roleConvert(text: role.rawValue), name: name, location: location, email: email)) {
                                userCreated.toggle()
                            } else {
                                alert.toggle()
                                alertMsg = "Try again later"
                            }
                        }
                    }
                } label: {
                    Text("Submit")
                }
                .buttonStyle(.bordered)
                .disabled(error.contains(true))
            }
        }
        .alert("Failed user creation", isPresented: $alert) {
            Button("OK") {}
        } message: {
            Text(alertMsg)
        }
        .alert(locked ? "User modified" : "User created", isPresented: $userCreated) {
            Button("OK") {
                if locked {
                    Task {
                        await vm.getUser(email: vm.userData.email)
                    }
                } else {
                    email = ""
                    name = ""
                    location = ""
                    newUser.toggle()
                }
            }
        } message: {
            Text(alertMsg)
        }
        .onAppear {
            if locked {
                email = vm.userData.email
                name = vm.userData.name
                location = vm.userData.location
            }
        }
    }
}

struct NewUserView_Previews: PreviewProvider {
    static var previews: some View {
        NewUserView(user: false,locked: false, newUser: .constant(false))
            .environmentObject(GeneralViewModel())
    }
}
