//
//  DetailOrderView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 24/2/23.
//

import SwiftUI

struct DetailOrderView: View {
    @EnvironmentObject var vm: GeneralViewModel
    @Environment(\.dismiss) private var dismiss
    let order:Order
    
    @State var books: [Book] = []
    
    @State var status: Status = .returned
    @State var alert = false
    var body: some View {
        Form {
            Section("Order ID") {
                Text(order.id)
            }
            Section("Order date") {
                Text(vm.dateConverse(text: order.date))
            }
            Section("User") {
                Text(order.email)
            }
            Section("Order") {
                ForEach(books) { book in
                    HStack {
                        CoverView(url: book.cover)
                            .frame(width: 80, height: 100)
                        VStack(alignment: .leading) {
                            Text("ID: \(book.id)").bold()
                            Text(book.title)
                                .italic()
                                .lineLimit(1)
                            Text(vm.authors[book.author] ?? "Not Available")
                                .font(.caption.italic())
                        }
                    }
                }
            }
            Section("Change status") {
                Picker("Order Status", selection: $status) {
                    ForEach(Status.allCases, id:\.self) { cases in
                        Text(vm.statusConverse(enSp: false, text: cases.rawValue).capitalized)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    Task {
                        if await vm.changeStatus(order: ChangeStatusOrder(id: order.id, estado: status.rawValue, admin: vm.userData.email)) {
                            await vm.allUserOrders()
                            dismiss()
                        } else {
                            alert.toggle()
                        }
                    }
                }
            }
        }
        .alert("Conexion error",
               isPresented: $alert) {
            Button(action:{}) {
                Text("OK")
            }
        } message: {
            Text("The status has not been changed")
        }
        .onAppear {
            books = vm.booksId(ids: order.books)
            status = vm.statusEnum(text: order.estado)
        }
    }
}

struct DetailOrderView_Previews: PreviewProvider {
    static let vm = GeneralViewModel()
    static var previews: some View {
        NavigationStack {
            DetailOrderView(order: .test)
                .environmentObject(vm)
                .task {
                    await vm.getBooks()
                }
        }
    }
}
