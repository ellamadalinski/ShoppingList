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
    
    var cart : [Item] = []
    var start = Item(name: "Bread", price: 3.75)
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var itemNameTextFieldOutlet: UITextField!
    @IBOutlet weak var itemPriceTextFieldOutlet: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        cart.append(start)
        if let it = UserDefaults.standard.data(forKey: "myCart") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Item].self, from: it) {
                cart = decoded
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = cart[indexPath.row].name
        cell.detailTextLabel?.text = String(cart[indexPath.row].price)
        return cell
    }
    
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        if itemNameTextFieldOutlet.text != "" && itemPriceTextFieldOutlet.text != ""{
            if let n = itemNameTextFieldOutlet.text{
                if let p1 = itemPriceTextFieldOutlet.text{
                    if let p = Double(p1){
                        var newItem = Item(name: n, price: p)
                        cart.append(newItem)
                        tableViewOutlet.reloadData()
                        itemNameTextFieldOutlet.text = ""
                        itemPriceTextFieldOutlet.text = ""
                    }
                }
            }
        }
        
        else{
            let alert = UIAlertController(title: "Error", message: "1+ Text Fields Not Filled Out", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            cart.remove(at: indexPath.row)
            tableViewOutlet.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cart) {
            UserDefaults.standard.set(encoded, forKey: "myCart")
        }
    }
    
    
}

