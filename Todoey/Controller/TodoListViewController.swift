//
//  ViewController.swift
//  Todoey
//
//  Created by Ivan Kočiš on 27/03/2018.
//  Copyright © 2018 toorpia. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Items]()
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(defaults.array(forKey: "ToDoListArray") as? [String])
        
        let newItem = Items()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Items()
        newItem2.title = "Buy EGGZ"
        itemArray.append(newItem2)

        let newItem3 = Items()
        newItem3.title = "GoTo somewhere"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Items] {
            itemArray = items
        }
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]

        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = item.done ? .checkmark : .none
  
//        same shit as this
//        if item.done == true { cell.accessoryType = .checkmark } else { cell.accessoryType = .none }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - add new items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoyes item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen once the user clicks the Add item button on UIAlert
            let newItem = Items()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}

