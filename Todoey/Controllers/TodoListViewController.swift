//
//  ViewController.swift
//  Todoey
//
//  Created by Klemen Brecko on 13/04/2021.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(realm.configuration.fileURL!)
        
    }

    //MARK: -Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            
            // Ternary operator
            // value = condition ? valueIfTrue : valueIfFalse
            
            
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added"
        }
        
        
        
        
        // Vse spodaj je enako temu zgoraj
        //        if item.done == true{
        //            cell.accessoryType = .checkmark
        //        }else{
        //            cell.accessoryType = .none
        //        }
        
        
        
        return cell
        
    }
    
    
    //MARK: -Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            
            do {
                try realm.write{
//                   item.done = !item.done  -> za obklukat
                    realm.delete(item) // -> za izbrisat
                }
            } catch {
                print("Error saving done status, \(error)")
            }
            
        }
        self.tableView.reloadData()
        
        
        //print(todoItems[indexPath.row])
       
//        context.delete(todoItems[indexPath.row])
//
//        todoItems.remove(at: indexPath.row)
        
        
//        todoItems![indexPath.row].done = !((todoItems?[indexPath.row].done)!)
        
        
//        save(item: Item())
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // what will happen when user clicks add item
            
            
            
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch  {
                    print("Couldn't append new item to realm")
                }
                
            }
            self.tableView.reloadData()
           
            
            
            
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new todo"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func save(item: Item){
        
        do{
            try realm.write{
                realm.add(item)
            }
            
        }
        catch{
            print("Error saving item, \(error)")
        }
        
        
        
        self.tableView.reloadData()
}
    func loadItems(){

        todoItems =  selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
//            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name)
//
//        if let additionalPredicate = predicate{
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }else{
//            request.predicate = categoryPredicate
//        }
////        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate] )
////
////        request.predicate = compoundPredicate
//
//        do{
//                itemArray = try context.fetch(request)
//            }catch{
//                print("Error fetching data from context \(error)")
//            }
        tableView.reloadData()
        }

}

// MARK: - Search bar methods extension
extension TodoListViewController : UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated",  ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }

}
