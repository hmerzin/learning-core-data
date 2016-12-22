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
    var objectsArray = [NSManagedObject]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notebook")
        do {
            let objects = try AppDelegate().persistentContainer.viewContext.fetch(fetchRequest) as! [NSManagedObject]
            namesArray = optimize(objects: objects)
            objectsArray = objects
        } catch {
            fatalError("couldn't fetch")
        }
    }
    
    func optimize(objects: [NSManagedObject]) -> [String]? {
        var names = [String] ()
        for object in objects {
            if let name = object.value(forKey: "name") {
                names.append((name as! String))
            }
        }
        if((names.count) > 0) {
            return names
        } else {
            return []
        }
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
        return (namesArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = appDelegate.persistentContainer.viewContext
        let object = objectsArray[indexPath.row] as NSManagedObject
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "notebookCell") as! NotebooksCell
        let name = namesArray?[indexPath.row]
        //TODO: set text
        cell.label.text = name 
        return cell
    }
    
    func save(name: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Notebook", in: appDelegate.persistentContainer.viewContext)
        let newNotebook = NSManagedObject(entity: entity!, insertInto: appDelegate.persistentContainer.viewContext)
        newNotebook.setValue(name, forKey: "name")
        namesArray?.append(name)
        tableView.reloadData()
        do {
            try appDelegate.persistentContainer.viewContext.save()
        } catch {
            fatalError("couldn't save context")
        }
    }
    
}
