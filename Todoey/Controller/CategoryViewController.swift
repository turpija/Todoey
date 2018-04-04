//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ivan Kočiš on 03/04/2018.
//  Copyright © 2018 toorpia. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    var categoryArray = [CategoryEntity]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    //MARK: - TableView Datasource methods
    //setup data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        // cell.accessoryType = item.done ? .checkmark : .none
        
        //        same shit as this
        //        if item.done == true { cell.accessoryType = .checkmark } else { cell.accessoryType = .none }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("klik na \(indexPath)")
    }
    
    //MARK: - TableView Delegate methods
    // save data and load data
    
    //MARK: - Add New categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoyes category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add new category", style: .default) { (action) in
            //what will happen once the user clicks the Add item button on UIAlert
            let newCategory = CategoryEntity(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data manipulation methods
    
    func saveCategories() {
        print("pokrećem sejv...")
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()){
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print ("error fetching data from context \(error)")
        }
        tableView.reloadData()
        
    }
    
}
