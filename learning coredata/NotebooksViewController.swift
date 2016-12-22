//
//  ViewController.swift
//  learning coredata
//
//  Created by Harry Merzin on 12/18/16.
//  Copyright © 2016 Harry Merzin. All rights reserved.
//

import UIKit
import CoreData

class NotebooksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var notebooksArray: [NSManagedObject]?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notebook")
        do {
            notebooksArray = try AppDelegate().persistentContainer.viewContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            fatalError("could not execute fetchrequest \(error)")
        }
        print("count: \(notebooksArray?.count)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(notebooksArray!.count)
        return notebooksArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notebookCell")! as! NotebooksCell

        print("row: \(indexPath.row)")
        print("notnil")
        let name: String = ((notebooksArray?[indexPath.row])! as NSManagedObject).value(forKey: "name") as! String
        print("name: \(name)")
        cell.label.text = "\(name)"
        return cell
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
    
    func save(name: String) {
        let context = AppDelegate().persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Notebook", in: context)
        let newNotebook = NSManagedObject(entity: entity!, insertInto: context)
        newNotebook.setValue(name, forKey: "name")
        notebooksArray?.append(newNotebook)
        print("count: \(notebooksArray?.count)")
        print("indexof: \(notebooksArray?.index(of: newNotebook))")
        //print("newNotebook: \(notebooksArray?[(notebooksArray?.count)! - 1])")
        tableView.reloadData()
        print("--------------------------------------")
        do {
            try context.save()
        } catch {
            //fatalError("could not save context error: \(error)")
        }
        
    }
    
    
    @IBAction func add(_ sender: Any) {
        presentAddAlert()
    }

    
    
    
    
}



