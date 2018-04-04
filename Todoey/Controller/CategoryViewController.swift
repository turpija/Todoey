//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ivan Kočiš on 03/04/2018.
//  Copyright © 2018 toorpia. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift


class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?

 //   var categories = [Category]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    //MARK: - TableView Datasource methods
    //setup data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
//        let category = categories[indexPath.row]
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "no categories added yet"
        
        // cell.accessoryType = item.done ? .checkmark : .none
        
        //        same shit as this
        //        if item.done == true { cell.accessoryType = .checkmark } else { cell.accessoryType = .none }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("klik na \(indexPath)")
        performSegue(withIdentifier: "goToItems", sender: self)

        tableView.reloadRows(at: [indexPath], with: .fade)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - TableView Delegate methods
    // save data and load data
    
    //MARK: - Add New categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
      
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen once the user clicks the Add item button on UIAlert
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data manipulation methods
    
    func save(category: Category) {
        print("pokrećem sejv...")
        do {
            try realm.write {
                try realm.add(category)
            }
        } catch {
            print("error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
     }

}
