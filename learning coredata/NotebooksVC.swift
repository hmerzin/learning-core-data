//
//  NotebooksVC.swift
//  learning coredata
//
//  Created by Harry Merzin on 12/20/16.
//  Copyright © 2016 Harry Merzin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NotebooksVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var namesArray: [String]?
    var objectsArray = [Notebook]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let array = ["asdf", "harry", "merzin", "1234"]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest = NSFetchRequest<Notebook>(entityName: "Notebook")
        do {
             try objectsArray = appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            fatalError("couldn't fetch")
        }
        print(objectsArray.count)
        //self.tableView.register(NotebooksCell.self, forCellReuseIdentifier: "notebookCell")
    }
    
    func presentAddAlert() {
        let alert = UIAlertController(title: "New Notebook", message: "Add a new notebook", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) -> Void in
            let textField = alert.textFields!.first
            self.save(name: (textField?.text)!)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextField {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func add(_ sender: Any) {
        presentAddAlert()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsArray.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "NotesVC") as! NotesVC
        viewController.notebook = objectsArray[indexPath.row]
        self.present(viewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = appDelegate.persistentContainer.viewContext
        let object = objectsArray[indexPath.row] as Notebook
        namesArray?.remove(at: indexPath.row)
        do {
            try print("before", context.count(for: NSFetchRequest<NSFetchRequestResult>(entityName: "Notebook")))
        } catch {
            print("fail")
        }
        
        context.delete(object)
        
        do {
            try print("after", context.count(for: NSFetchRequest<NSFetchRequestResult>(entityName: "Notebook")))
        } catch {
            print("fail")
        }
        do {
            try context.save()
        } catch {
            fatalError("couldn't delete item")
        }
        //print("count: \(objectsArray.count)")
        //print("index: \(objectsArray.index(of: object))")
        objectsArray.remove(at: objectsArray.index(of: object)!)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notebookCell", for: indexPath) as! NotebooksCell
        let name = objectsArray[indexPath.row].name
        cell.label?.text = name
        return cell
    }
    
    func save(name: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Notebook", in: appDelegate.persistentContainer.viewContext)
        let newNotebook = NSManagedObject(entity: entity!, insertInto: appDelegate.persistentContainer.viewContext)
        newNotebook.setValue(name, forKey: "name")
        objectsArray.append(newNotebook as! Notebook)
        namesArray?.append(name)
        tableView.reloadData()
        do {
            try appDelegate.persistentContainer.viewContext.save()
        } catch {
            fatalError("couldn't save context")
        }
    }
    
}
