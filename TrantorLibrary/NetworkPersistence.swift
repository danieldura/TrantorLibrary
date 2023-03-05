//
//  NetworkPersistence.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 15/2/23.
//

import Foundation
final class NetworkPersistance {
    static let shared = NetworkPersistance()
    
    // Func User
    func getUser(user: FindUser) async throws -> UserData {
        try await queryJSON(request: .request(url: .getUser, method: .post, body: user), type: UserData.self)
    }
    
    func newUser(user: NewUser) async throws -> Bool {
        do {
            return try await queryJSON(request: .request(url: .newUser, method: .put, body: user))
        } catch let error {
            throw error
        }
    }
    
    func getReaded(user: FindUser) async throws -> ReadedBooks {
        do {
            return try await queryJSON(request: .request(url: .getReaded, method: .post, body: user), type: ReadedBooks.self)
        } catch let error {
            throw error
        }
    }
    
    func postRead(readed: ReadedBooks) async throws -> Bool {
        do {
            return try await queryJSON(request: .request(url: .postReaded, method: .post, body: readed))
        } catch let error {
            throw error
        }
    }
    
    // Func Books
    func getBooks() async throws -> [Book] {
        let (data, _) = try await URLSession.shared.data(from: .getBooks)
        return try JSONDecoder().decode([Book].self, from: data)
    }
    
    func getLatest() async throws -> [Book] {
        let (data, _) = try await URLSession.shared.data(from: .getLatest)
        return try JSONDecoder().decode([Book].self, from: data)
    }
    
    // Func Authors
    func getAuthors() async throws -> [Author] {
        let (data, _) = try await URLSession.shared.data(from: .getAutors)
        return try JSONDecoder().decode([Author].self, from: data)
    }
    
    // func search
    func getSearchBook(search: String) async throws -> [Book] {
        let (data, _) = try await URLSession.shared.data(from: .searchBook(search: search))
        return try JSONDecoder().decode([Book].self, from: data)
    }

    // func orders
    func newOrder(order: NewOrder) async throws -> Bool {
        try await queryJSON(request: .request(url:.newOrder , method: .post, body: order))
    }
    
    func userOrders(user: FindUserOrders) async throws -> [Order] {
        try await queryJSON(request: .request(url: .userOrders, method: .post, body: user), type: [Order].self)
    }
    
    func allUserOrders(user: FindUserOrders) async throws -> [Order] {
        try await queryJSON(request: .request(url: .allOrders, method: .post, body: user), type: [Order].self)
    }
    
    func changeStatus(order: ChangeStatusOrder) async throws -> Bool {
        try await queryJSON(request: .request(url: .changeStatus, method: .put, body: order))
    }
    
// Func querys
    func queryJSON(request:URLRequest,
                   statusOK:Int = 200) async throws -> Bool {
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw APIErrors.nonHTTP }
            if response.statusCode == statusOK {
                return true
            } else {
                throw APIErrors.status(response.statusCode)
            }
        } catch let error as APIErrors {
            throw error
        } catch {
            throw APIErrors.general(error)
        }
    }
    
    func queryJSON<T:Codable>(request:URLRequest,
                              type:T.Type,
                              decoder:JSONDecoder = JSONDecoder(),
                              statusOK:Int = 200) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw APIErrors.nonHTTP }
            if response.statusCode == statusOK {
                do {
                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw APIErrors.json(error)
                }
            } else {
                throw APIErrors.status(response.statusCode)
            }
        } catch let error as APIErrors {
            throw error
        } catch {
            throw APIErrors.general(error)
        }
    }
    
}
