//
//  ModelDefinition.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 15/2/23.
//

import Foundation
// body POST data user
struct FindUser: Codable {
    var email:String
}

struct UserData: Codable {
    let name: String
    let email: String
    let location: String
    let role: String
}
// json replay POST data user
struct UserQuery: Codable {
    var error: String
    var reason: String
}

// json New User

struct NewUser: Codable {
    var role: String
    var name: String
    var location: String
    var email: String
}

// json Books

struct Book: Codable, Identifiable, Hashable {
    let id: Int
    let pages: Int?
    let summary: String?
    let cover: URL?
    let year: Int
    let author: String
    let isbn: String?
    let title: String
    let price: Double
    let plot: String?
    let rating: Double?
}


// json Authors

struct Author: Codable, Identifiable {
    let id: String
    let name: String
}

// json NewOrder

struct NewOrder: Codable {
    let email: String
    let pedido: [Int]
}

// json user orders
struct FindUserOrders: Codable {
    let email: String
}

struct Order: Codable, Hashable, Identifiable {
    let id: String
    let email: String
    let books: [Int]
    let estado: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case id = "npedido"
        case email
        case books
        case estado
        case date
    }
}

struct ChangeStatusOrder: Codable, Hashable {
    let id: String
    let estado: String
    let admin: String
}

struct ReadedBooks: Codable, Hashable {
    let books: [Int]
    let email: String
}

struct ReadedBook: Codable, Hashable {
    let email: String
    let books: [Int]
}

struct Option: Hashable {
    let name: String
    let image: String
    let option: Options
}
// enums

enum Screens {
    case animation
    case login
    case userHome
    case adminHome
}

enum HomeScreens {
    case home
    case category
}

enum Categories: String, CaseIterable{
    case topRated = "Top Rated"
    case byPrice  = "By Price"
    case byAuthor = "By Author"
}

enum SortPrice {
    case ascending
    case descending
}

enum Status:String, CaseIterable {
    case recived    = "recibido"
    case processing = "procesando"
    case send       = "enviado"
    case delivered  = "entregado"
    case returned   = "devuelto"
    case cancelled  = "anulado"
}

enum Role: String, CaseIterable {
    case admin = "Admin"
    case user = "User"
}

enum Options: String, CaseIterable {
    case readed = "Readed books"
    case orders = "Orders"
    case data   = "User data"
}

extension Book {
    static let test = Book(id: 1, pages: 123, summary: "hashsajhkdasjhkdashjkdashjkasdhjkadshjkasdhjksadhjkadshjkdsahjk jhsjkhs sj jhasdhjkdsahjkadshjsahjasd dasdsahjkadsj dsaads asdj jhkadshjkadsjhksadhjkas  sdajjsdhjsahjkashjkashjkashjkasdhjkadsjhkdjhkad jkhjksahjkadsjhkadsjkhhashsajhkdasjhkdashjkdashjkasdhjkadshjkasdhjksadhjkadshjkdsahjk jhsjkhs sj jhasdhjkdsahjkadshjsahjasd dasdsahjkadsj dsaads asdj jhkadshjkadsjhksadhjkas  sdajjsdhjsahjkashjkashjkashjkasdhjkadsjhkdjhkad jkhjksahjkadsjhkadsjkh", cover: URL(string: "https://images.gr-assets.com/books/1327942880l/2493.jpg"), year: 2022, author: "Autor", isbn: "1234-1234-5678-3455", title: "Libro 1 con titulo muuuuy largoooooo", price:20.95000, plot: "kjsdkjsjdjhdjdjjdjdsfj sjfkjhfashjkfdshjkfjhhjk jfhk jhfkdsa jfhjl lhjadf ljdfsljkfd ajkfdh kjfh jklh fkjl  fjh hjfdsj khjlfsa jksfd lhjkdajk sfh lkjsdfhljkadshfa kjahfds jkhdskdjl hjkdha jd ajd ahfjkd jkdsfjkewhj ekfjjdsfhl sdkjhf lkjdfsh kjhk jh dsljksfdah kjdjknldsjlsdjlkjsdkjsjdjhdjdjjdjdsfj sjfkjhfashjkfdshjkfjhhjk jfhk jhfkdsa jfhjl lhjadf ljdfsljkfd ajkfdh kjfh jklh fkjl  fjh hjfdsj khjlfsa jksfd lhjkdajk sfh lkjsdfhljkadshfa kjahfds jkhdskdjl hjkdha jd ajd ahfjkd jkdsfjkewhj ekfjjdsfhl sdkjhf lkjdfsh kjhk jh dsljksfdah kjdjknldsjlsdjl", rating: 4.3)
}

extension Order {
    static let test = Order(id: "799ECFAA-5209-4DC2-A75A-FAE6ADD8CBFB", email: "joyce.admin@bookaloo.com", books: [4,1,1,2], estado: "procesando", date: "2023-02-11T18:45:25Z")
}

