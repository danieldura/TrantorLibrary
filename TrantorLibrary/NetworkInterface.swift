//
//  NetworkInterface.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 15/2/23.
//

import Foundation

enum APIErrors:Error {
    case general(Error)
    case json(Error)
    case nonHTTP
    case status(Int)
    case invalidData
    
    var description:String {
        switch self {
        case .general(let error):
            return "General error: \(error)."
        case .json(let error):
            return "JSON Error: \(error)."
        case .nonHTTP:
            return "Non HTTP connection."
        case .status(let int):
            if int == 404 {
                return "Not found"
            } else {
                return "Status error: Code \(int)."
            }
        case .invalidData:
            return "Invalid data."
        }
    }
}

enum HTTPMethod:String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

let serverURL = URL(string: "https://trantorapi-acacademy.herokuapp.com/api")!

extension URL {
// URLs User
    static let getUser = serverURL.appending(component: "client").appending(component: "query")
    static let newUser = serverURL.appending(component: "client")
    static let getReaded = serverURL.appending(component: "client").appending(component: "readedBooks")
    static let postReaded = serverURL.appending(component: "client").appending(component: "readQuery")

// URLs Books
    static let getBooks = serverURL.appending(component: "books").appending(component: "list")
    static let getLatest = serverURL.appending(component: "books").appending(component: "latest")

// URL autohrs
    static let getAutors = serverURL.appending(component: "books").appending(component: "authors")
    
// URL searchBooks
    static func searchBook(search:String) -> URL {
        serverURL.appending(component: "books").appending(component: "find").appending(component: "\(search.lowercased())")
    }

// URL orders
    static let newOrder = serverURL.appending(component: "shop").appending(component: "newOrder")
    
    static let userOrders = serverURL.appending(component: "shop").appending(component: "orders")
    
    static let allOrders = serverURL.appending(component: "shop").appending(components: "allOrders")
    
    static let changeStatus = serverURL.appending(component: "shop").appending(components: "orderStatus")
    
}

extension URLRequest {
    static func request<T:Codable>(url:URL, method:HTTPMethod, body:T) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = try? JSONEncoder().encode(body)
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
