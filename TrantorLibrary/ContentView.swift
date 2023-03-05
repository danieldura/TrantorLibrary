//
//  ContentView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 21/2/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: GeneralViewModel
    
    var body: some View {
        switch vm.screen {
        case .animation:
            AnimationView()
        case .login:
            LoginView()
        case .userHome:
            UserView()
        case .adminHome:
            AdminView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(GeneralViewModel())
    }
}
