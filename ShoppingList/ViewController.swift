//
//  ViewController.swift
//  ShoppingList
//
//  Created by Ella Madalinski on 10/24/21.
//

import UIKit

public class Item: Codable{
    
    var name : String
    var price : Double
    
    init(name : String, price : Double){
        self.name = name
        self.price = price
    }
}

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var list : [Item] = []
    var cart : [Item] = []
    var start = Item(name: "Bread", price: 3.75)
    let defaults = UserDefaults.standard
    var n : String = ""
    var p : String = ""
    var totalPrice : Double = 0.0
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var itemNameTextFieldOutlet: UITextField!
    @IBOutlet weak var itemPriceTextFieldOutlet: UITextField!
    @IBOutlet weak var cartTextViewOutlet: UITextView!
    @IBOutlet weak var totalPriceLabelOutlet: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        list.append(start)
        if let it = UserDefaults.standard.data(forKey: "myList") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Item].self, from: it) {
                list = decoded
            }
        }
        
        if let it2 = UserDefaults.standard.data(forKey: "myCart"){
            let decoder2 = JSONDecoder()
            if let decoded2 = try? decoder2.decode([Item].self, from: it2){
                cart = decoded2
                for blah in cart {
                    cartTextViewOutlet.text += "\(blah.name)\n"
                    totalPrice += blah.price
                }
                //totalPriceLabelOutlet.text = //FINISH
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row].name
        cell.detailTextLabel?.text = String(list[indexPath.row].price)
        return cell
    }
    
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        
        
        
        if itemNameTextFieldOutlet.text != "" && itemPriceTextFieldOutlet.text != ""{
            if let n = itemNameTextFieldOutlet.text{
                if let p1 = itemPriceTextFieldOutlet.text{
                    if let p = Double(p1){
                        var newItem = Item(name: n, price: p)
                        var doesThisHappen = false
                        
                        if list.count != 0{
                            for blah in list {
                                if newItem.name == blah.name{
                                    doesThisHappen = true
                                    let alert = UIAlertController(title: "Error", message: "Item already in list- Add different item", preferredStyle: .alert)
                                    let action = UIAlertAction(title: "Ok", style: .default) { action in
                                        self.itemNameTextFieldOutlet.text = ""
                                        self.itemPriceTextFieldOutlet.text = ""
                                    }
                                    alert.addAction(action)
                                    present(alert, animated: true, completion: nil)
                                }
                            }
                            if doesThisHappen == false{
                                list.append(newItem)
                                tableViewOutlet.reloadData()
                                itemNameTextFieldOutlet.text = ""
                                itemPriceTextFieldOutlet.text = ""
                            }
                        }
                        else{
                            list.append(newItem)
                            tableViewOutlet.reloadData()
                            itemNameTextFieldOutlet.text = ""
                            itemPriceTextFieldOutlet.text = ""
                        }
                        
                    }
                }
            }
        }
        
        else{
            let alert = UIAlertController(title: "Error", message: "Name and/or Price Not Filled Out", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            list.remove(at: indexPath.row)
            tableViewOutlet.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        totalPrice += list[indexPath.row].price
        cart.append(list[indexPath.row])
        totalPriceLabelOutlet.text = "Total Price: $\(totalPrice)"
        cartTextViewOutlet.text += "\(list[indexPath.row].name)\n"
        list.remove(at: indexPath.row)
        tableViewOutlet.reloadData()
    }
    
    
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(list) {
            UserDefaults.standard.set(encoded, forKey: "myList")
        }
        
        if let encoded2 = try? encoder.encode(cart){
            UserDefaults.standard.set(encoded2, forKey: "myCart")
        }
        
    }
    
    
}








//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
//            let alert = UIAlertController(title: "Edit Item", message: "", preferredStyle: .alert)
//            alert.addTextField { (textField1) in
//                textField1.placeholder = "Item Name"
//                if let n1 = textField1.text{
//                    self.n = n1
//                }
//            }
//
//            alert.addTextField { (textField2) in
//                textField2.placeholder = "Item Price"
//                if let p1 = textField2.text{
//                    self.p = p1
//                }
//            }
//            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
//                self.cart[indexPath.row].name = self.n
//                if let p2 = Double(self.p){
//                    self.cart[indexPath.row].price = p2
//                }
//            }))
//        }
//
//        tableViewOutlet.reloadData()
//        return [editAction]
//
//    }
