//
//  AnimationView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 2/3/23.
//

import SwiftUI

struct AnimationView: View {
    @EnvironmentObject var vm: GeneralViewModel
    @State var animation = false
    
    var body: some View {
        ZStack {
            Image("trantor")
                .resizable()
                .scaledToFill()
            Text("Trantor\n Library")
                .font(.custom("Snell Roundhand", size: 100))
                .bold()
                .foregroundColor(.white)
                .offset(x: animation ? -40 : 300)
        }
        .ignoresSafeArea()
        .onAppear {
            animation = true
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                vm.screen = .login
            }
        }
        .animation(.easeOut(duration: 4), value: animation)
    }
}

struct AnimationView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationView()
            .environmentObject(GeneralViewModel())
    }
}
