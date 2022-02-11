//
//  ViewController.swift
//  Firebase101
//
//  Created by 정현준 on 2021/06/09.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var numOfCustomers: UILabel!
    let db = Database.database().reference()

    var customers: [Customer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateLable()
        saveBasicTypes()
//        saveCustomers()
        fetchCustomers()

        // 데이터 업데이트, 삭제
//        updateBasicTypes()
//        deleteBasicTypes()
    }


    func updateLable() {
        db.child("firstData").observeSingleEvent(of: .value){ snapshot in
            print("==> \(snapshot)")

            let value = snapshot.value as? String ?? ""

            DispatchQueue.main.async {
                self.dataLabel.text = value
            }
        }
    }
    
    @IBAction func createCustomer(_ sender: Any) {
        saveCustomers()
    }
    

    @IBAction func fetchCustomer(_ sender: Any) {
        fetchCustomers()
    }

    func updateCustomer() {
        guard customers.isEmpty == false else {return}
        customers[0].name = "min"

        let dictionary = customers.map{$0.toDictionary}
        db.updateChildValues(["customers": dictionary])
    }

    @IBAction func updateCustomer(_ sender: Any) {
        updateCustomer()
    }

    func deleteCustomer() {
        db.child("customers").removeValue()
    }

    @IBAction func deleteCustomer(_ sender: Any) {
        deleteCustomer()
    }


}

extension ViewController {
    func saveBasicTypes() {
        // Firebase Chile ("key").setValue("value")
        // - string, number, dictionary, array

        db.child("int").setValue(3)
        db.child("double").setValue(3.5)
        db.child("str").setValue("string value == 여러분 안녕")
        db.child("array").setValue(["a","b","c"])
        db.child("dict").setValue(["id":"anyID", "age":10, "city":"seoul"])
    }

    func saveCustomers(){
        // 서점에서 사용자 정보 저장
        // Customer 모델, book 모델 생성

        let books = [Book(title: "Good to Great", author: "Someone"), Book(title: "Hacking Growth", author: "Somebody")]

        let customer1 = Customer(id: "\(Customer.id)", name: "Son", books: books)
        Customer.id += 1 // 다음 고객 등록시 id 미리 생성

        let customer2 = Customer(id: "\(Customer.id)", name: "Dale", books: books)
        Customer.id += 1

        let customer3 = Customer(id: "\(Customer.id)", name: "Kane", books: books)
        Customer.id += 1

        db.child("customers").child(customer1.id).setValue(customer1.toDictionary)
        db.child("customers").child(customer2.id).setValue(customer2.toDictionary)
        db.child("customers").child(customer3.id).setValue(customer3.toDictionary)
    }
}

// MARK: Read (Fetch) Data
extension ViewController {
    func fetchCustomers(){
        db.child("customers").observeSingleEvent(of: .value) { snapshot in
            print("==> \(snapshot.value)")
            do {
                let data = try JSONSerialization.data(withJSONObject: snapshot.value, options: [])

                let decoder = JSONDecoder()
                let customers: [Customer] = try decoder.decode([Customer].self, from: data)

                // ViewController 클래스 맨 앞에서 생성한 customers에 집어넣음 (업데이트시 활용)
                self.customers = customers

                DispatchQueue.main.async {
                    self.numOfCustomers.text = " # of Customers: \(customers.count)"
                }

                print("===> # of customers: \(customers.count)")
            } catch {
                print("====> error: \(error.localizedDescription)")
            }
        }
    }
}

extension ViewController {
    func updateBasicTypes(){
        //        db.child("int").setValue(3)
        //        db.child("double").setValue(3.5)
        //        db.child("str").setValue("string value == 여러분 안녕")

        db.updateChildValues(["int": 6])
        db.updateChildValues(["double": 5.4])
        db.updateChildValues(["str": "변경된 스트링 업데이트하기"])
    }
    func deleteBasicTypes(){
        db.child("int").removeValue()
        db.child("double").removeValue()
        db.child("str").removeValue()
    }
}

// ex) 서점 고객 데이터를 보낸다고 한다면?
struct Customer: Codable {
    let id: String
    var name: String
    let books: [Book]

    var toDictionary: [String: Any] {
        // 각 책들을 dictionary화 한 것을 모아놓은 Array 생성
        let booksArray = books.map{$0.toDictionary}
        // 표현할 것: 고객id, 고객 이름, 구매한 책 목록
        let dict: [String: Any] = ["id":id, "name":name, "books": booksArray]
        return dict
    }

    // id 초기생성
    static var id: Int = 0
}

struct Book: Codable {
    let title: String
    let author: String

    var toDictionary: [String: Any] {
        let dict: [String: Any] = ["title": title, "author": author]
        return dict
    }
}
