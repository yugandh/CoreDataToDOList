//
//  ViewController.swift
//  CoreDataToDOList
//
//  Created by Yugandhar Kommineni on 11/13/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var addPerson: UIButton!
    @IBOutlet weak var personTableView: UITableView!
    // reference to managed object contect
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items: [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.personTableView.delegate = self
        self.personTableView.dataSource = self
        self.fetchPeople()
    }
    
    @IBAction func AddPersonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Person", message: "What's there name?", preferredStyle: .alert)
        alert.addTextField()
        let submitButton = UIAlertAction(title: "Add", style: .default, handler: { (action) in
            let textField = alert.textFields![0]
            
            // Create object
            let newPerson = Person(context: self.context)
            newPerson.name = textField.text
            
            // Save Object
            do {
                try self.context.save()
                self.fetchPeople()
            } catch {
                
            }
        })
        
        
        
        
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchPeople() {
        do {
            
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            // filter
//            let pred = NSPredicate(format: "name CONTAINS %@", "yug")
//            request.predicate = pred
        
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            
            self.items =  try  context.fetch(request)
            DispatchQueue.main.async {
                self.personTableView.reloadData()
            }
        } catch {
            
        }
        
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "yug") as? PersonTableViewCell else {
            return UITableViewCell()
        }
        if let person = self.items?[indexPath.row] {
            cell.name.text = person.name
        }
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete", handler: {
            (action, view, completionHandler) in
            let remove = self.items![indexPath.row]
            self.context.delete(remove)
            do {
                try self.context.save()
            } catch {
                
            }
            // re-fetch
            self.fetchPeople()
        })
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
