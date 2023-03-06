//
//  GeneralViewModel.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 15/2/23.
//

import Foundation

final class GeneralViewModel: ObservableObject {
    let persistence = NetworkPersistance.shared
    @Published var showAlertLogin = false
    
    @Published var showAlert = false
    @Published var errorMsg = ""
    @Published var loading = false
    
    @Published var screen: Screens = .animation
    @Published var homeScreen: HomeScreens = .home
    
    @Published var sortPrice: SortPrice = .descending
    
    @Published var options: Options = .readed
        
    @Published var email = ""
    @Published var userData: UserData = UserData(name: "", email: "", location: "", role: "")
    
    @Published var books: [Book] = []
    @Published var latest: [Book] = []
    @Published var authors: [String:String] = [:]
    @Published var readed: [Int] = []
    
    @Published var category: Categories = .byPrice
    var sortedBooks: [Book] {
        switch category {
        case .topRated:
            return books.sorted(by: {$0.rating ?? 0 > $1.rating ?? 0})
        case .byPrice:
            switch sortPrice {
            case .ascending:
                return books.sorted(by: {$0.price < $1.price})
            case .descending:
                return books.sorted(by: {$0.price > $1.price})
            }
        case .byAuthor:
            return []
        }
    }
    
    var booksAuthor:[[Book]] {
        Dictionary(grouping: books) { book in
            book.author
        }.values.sorted {
            $0.first?.author ?? "" < $1.first?.author ?? ""
        }
    }
    
    var sortBooksAuthor: [[Book]] {
        booksAuthor.sorted(by: {authors[$0.first?.author ?? ""] ?? "" < authors[$1.first?.author ?? ""] ?? ""})
    }
    
    var ordersByState: [String:[Order]] {
        Dictionary(grouping: orders) { order in
            order.estado
        }
    }
    
    @Published var search = ""
    
    @Published var cart: [Int] = []
    
    @Published var orders: [Order] = []

// functions
// func user
    @MainActor func getUser(email: String) async -> Bool {
        do {
            userData = try await persistence.getUser(user: FindUser(email: email))
            return true
        } catch let error as APIErrors {
            errorMsg = error.description
            showAlertLogin.toggle()
            return false
        } catch {
            errorMsg = error.localizedDescription
            showAlertLogin.toggle()
            return false
        }
    }
    
    @MainActor func newUser(user: NewUser) async -> Bool {
        do {
            return try await persistence.newUser(user: user)
        } catch let error as APIErrors {
            errorMsg = error.description
            showAlert.toggle()
            return false
        } catch {
            errorMsg = error.localizedDescription
            showAlert.toggle()
            return false
        }
    }
    
    func modifyUser(user: NewUser) async -> Bool {
        do {
            return try await persistence.newUser(user: user)
        } catch let error as APIErrors {
            errorMsg = error.description
            showAlert.toggle()
            return false
        } catch {
            errorMsg = error.localizedDescription
            showAlert.toggle()
            return false
        }
    }

// func data validation
    func validateEmpty(value: String) -> String? {
        if value.isEmpty {
            return "Field cannot be empty."
        } else {
            return nil
        }
    }
    
    func validateEmail(email: String) -> String? {
        do {
            let regex = try Regex(#"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"#)
            let email = try regex.wholeMatch(in: email)
            if let _ = email {
                return nil
            } else {
                return "This is not a valid email."
            }
        } catch {
            return "This is not a valid email."
        }
    }
    
    func validateEmail(email: String) -> Bool {
        do {
            let regex = try Regex(#"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"#)
            let email = try regex.wholeMatch(in: email)
            if let _ = email {
                return true
            } else {
                errorMsg = "This is not a valid email."
                showAlertLogin.toggle()
                return false
            }
        } catch {
            errorMsg = "This is not a valid email."
            showAlertLogin.toggle()
            return false
        }
    }
    
    @MainActor func getReaded(email: String) async {
        loading = false
        do {
            readed = try await persistence.getReaded(user: FindUser(email: email)).books
        } catch let error as APIErrors {
            errorMsg = error.description
            showAlert.toggle()
        } catch {
            errorMsg = error.localizedDescription
            showAlert.toggle()
        }
        loading = true
    }
    
    @MainActor
    func toggleReaded(readed: ReadedBooks) async -> Bool {
        loading = false
        do {
            _ = try await persistence.postRead(readed: readed)
        } catch let error as APIErrors {
            errorMsg = error.description
            showAlert.toggle()
            return false
        } catch {
            errorMsg = error.localizedDescription
            showAlert.toggle()
            return false
        }
        loading = true
        return true
    }
    
    
// func books
    @MainActor func getBooks() async {
        do {
            books = try await persistence.getBooks()
        } catch let error as APIErrors {
            errorMsg = error.description
            showAlert.toggle()
        } catch {
            errorMsg = error.localizedDescription
            showAlert.toggle()
        }
    }
    
    @MainActor func getLatest() async {
        loading = false
        do {
            latest = try await persistence.getLatest()
        } catch let error as APIErrors {
            errorMsg = error.description
            showAlert.toggle()
        } catch {
            errorMsg = error.localizedDescription
            showAlert.toggle()
        }
        loading = true
    }
    
    // search books by id -> book
    func booksId(ids: [Int]) -> [Book] {
        var cacheBook: [Book] = []
        if !ids.isEmpty {
            ids.forEach { id in
                if books.contains(where: {$0.id == id}) {
                    cacheBook.append(books.first(where: {$0.id == id})!)
                }
            }
        }
        return cacheBook
    }
    
    func bookId(id:Int) -> Book? {
        if books.contains(where: {$0.id == id}) {
            return books.first(where: {$0.id == id})
        } else {
            return nil
        }
    }

// func search
    func searchBook(search: String) async {
        do {
            books = try await persistence.getSearchBook(search: search)
        } catch {
            //errorMsg = error.localizedDescription
            //showAlert.toggle()
            books = []
        }
    }

// func authors
    @MainActor func getAuthors() async {
        do {
            let authorsJson = try await persistence.getAuthors()
            authorsJson.forEach { author in
                authors.updateValue(author.name, forKey: author.id)
            }
        } catch let error as APIErrors {
            errorMsg = error.description
            showAlert.toggle()
        } catch {
            errorMsg = error.localizedDescription
            showAlert.toggle()
        }
    }

// func cart
    
    func addToCart(book: Int) {
        if !cart.contains(where: {$0 == book}) {
            cart.append(book)
        }
    }
    
    func removeFromCart(book: Int) {
        cart.removeAll(where: {$0 == book})
    }
    
    func cartPrice() -> Double {
        var totalPrice = 0.0
        
        booksId(ids: cart).forEach { book in
            totalPrice += book.price
        }
        return totalPrice
    }
    
// func order
    
    func newOrder() async -> Bool {
        do {
            return try await persistence.newOrder(order: NewOrder(email: userData.email, pedido: cart))
        } catch let error as APIErrors {
            errorMsg = error.description
            showAlert.toggle()
            return false
        } catch {
            errorMsg = error.localizedDescription
            showAlert.toggle()
            return false
        }
    }
    
    @MainActor func userOrders() async {
        do {
            orders = try await persistence.userOrders(user: FindUserOrders(email: userData.email))
        } catch let error as APIErrors {
            errorMsg = error.description
            showAlert.toggle()
        } catch {
            errorMsg = error.localizedDescription
            showAlert.toggle()
        }
    }
    
    func orderPrice(books: [Int]) -> Double {
        var totalPrice = 0.0
        booksId(ids: books).forEach { book in
            totalPrice += book.price
        }
        return totalPrice
    }
    
    @MainActor func allUserOrders() async {
        do {
            orders = try await persistence.allUserOrders(user: FindUserOrders(email: userData.email))
        } catch let error as APIErrors {
            errorMsg = error.description
            showAlert.toggle()
        } catch {
            errorMsg = error.localizedDescription
            showAlert.toggle()
        }
    }
    
    @MainActor func changeStatus(order: ChangeStatusOrder) async -> Bool{
        do {
            return try await persistence.changeStatus(order: order)
        } catch let error as APIErrors {
            errorMsg = error.description
            showAlert.toggle()
            return false
        } catch {
            errorMsg = error.localizedDescription
            showAlert.toggle()
            return false
        }
    }
    
    
// other functions
    func roleConvert(text:String) -> String {
        switch text.lowercased() {
        case "user":
            return "usuario"
        case "admin":
            return "admin"
        default:
            ()
        }
        return ""
    }
    
    func dateConverse(text: String) -> String {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = dateFormatter.date(from: text)!
        
        dateFormatter.dateFormat = "dd-MM-yyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func doubleConvert(_ num: Double, decimal:Int) -> String {
        String(format: "%.\(decimal)f", num)
    }
    
    func statusConverse(enSp: Bool, text:String) -> String{
        if enSp {
            switch text.lowercased() {
            case "recived":
                return Status.recived.rawValue
            case "processing":
                return Status.processing.rawValue
            case "send":
                return Status.send.rawValue
            case "delivered":
                return Status.recived.rawValue
            case "returned":
                return Status.returned.rawValue
            case "cancelled":
                return Status.cancelled.rawValue
            default:
                ()
            }
        } else {
            switch text.lowercased() {
            case "recibido":
                return "recived"
            case "procesando":
                return "processing"
            case "enviado":
                return "send"
            case "entregado":
                return "recived"
            case "devuelto":
                return "returned"
            case "anulado":
                return "cancelled"
            default:
                ()
            }
        }
        return ""
    }
    
    func statusEnum (text: String) -> Status {
        switch text.lowercased() {
        case "recibido":
            return .recived
        case "procesando":
            return .processing
        case "enviado":
            return .send
        case "entregado":
            return .recived
        case "devuelto":
            return .returned
        case "anulado":
            return .cancelled
        default:
            ()
        }
        return .processing
    }
    
    func isReaded (id:Int) -> Bool {
        readed.contains(where: {$0 == id})
    }
}
