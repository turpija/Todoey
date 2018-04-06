//
//  ViewController.swift
//  Todoey
//
//  Created by Ivan Kočiš on 27/03/2018.
//  Copyright © 2018 toorpia. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    var realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(defaults.array(forKey: "ToDoListArray") as? [String])
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
       // loadItems()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "no items added"
        }
  
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("klik na \(indexPath)")
        
        if let item = todoItems? [indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
                } catch {
                    print ("error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - add new items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoyes item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen once the user clicks the Add item button on UIAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
//                        try self.realm.add(newItem)
                    }
                } catch {
                    print ("error saving item, \(error)")
                }
                
            }
            
            self.tableView.reloadData()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
       
    }
    
    
    // model manipulation methods

    
    func loadItems(){

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

    }
    
}
//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }


}



    
    
    


