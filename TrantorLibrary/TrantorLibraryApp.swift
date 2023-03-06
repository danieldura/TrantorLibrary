//
//  TrantorLibraryApp.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 15/2/23.
//

import SwiftUI

@main
struct TrantorLibraryApp: App {
    @StateObject var vm = GeneralViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .task {
                    _ = await (vm.getBooks(), vm.getLatest(), vm.getAuthors())
                }
        }
    }
}
