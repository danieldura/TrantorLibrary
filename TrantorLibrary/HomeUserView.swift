//
//  HomeUserView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 22/2/23.
//

import SwiftUI

struct HomeUserView: View {
    @EnvironmentObject var vm: GeneralViewModel

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    VStack (alignment: .leading){
                        Text("Hello,\(vm.userData.name)")
                            .font(.title.bold())
                            .lineLimit(1)
                        Text("Today's recommendation")
                            .font(.title.bold())
                    }
                    Spacer()
                }
                .padding(.leading)
                
                VStack {
                    if !vm.loading {
                        ProgressView()
                            .frame(height: 180)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(vm.latest) { book in
                                    NavigationLink(value: book) {
                                        CoverView(url: book.cover)
                                            .frame(width: 120, height: 180)
                                    }
                                    .navigationDestination(for: Book.self) { book in
                                        DetailView(book: book)
                                    }
                                }
                            }
                            
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 60)
                
                VStack(alignment: .leading) {
                    Text("Categories")
                        .font(.title2.bold())
                    List(Categories.allCases, id: \.self) { category in
                        NavigationLink(value: category) {
                            Text(category.rawValue)
                        }
                        .navigationDestination(for: Categories.self) { category in
                            SortCatalogueView(category: category)
                        }
                    }
                    .listStyle(.plain)
                    
                }
                Spacer()
            }
            .padding(.top)
        }
    }
}

struct HomeUserView_Previews: PreviewProvider {
    static let vm = GeneralViewModel()
    static var previews: some View {
        HomeUserView()
            .environmentObject(vm)
            .task {
                await vm.getLatest()
            }
    }
}
