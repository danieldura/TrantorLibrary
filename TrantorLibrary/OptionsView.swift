//
//  OptionsView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 3/3/23.
//

import SwiftUI

struct OptionsView: View {
    let option: Options
    
    @State var newUser = false
    
    var body: some View {
        switch option {
        case .readed:
            ReadedView(option: option)
        case .orders:
            UserOrderView(option: option)
        case .data:
            NewUserView(user: true, locked: true, newUser: $newUser)
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView(option: .readed)
    }
}
