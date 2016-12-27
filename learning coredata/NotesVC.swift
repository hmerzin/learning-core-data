//
//  NotesVC.swift
//  learning coredata
//
//  Created by Harry Merzin on 12/24/16.
//  Copyright © 2016 Harry Merzin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NotesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // use a stack or the other one to sort instead of nssort order to put in front of other notes
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var notebook: Notebook?
    var notesArray = [Note]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetch()
        tableView.reloadData()
    }
    
    func fetch() {
        let predicate = NSPredicate(format: "notebook = %@", argumentArray: [notebook!])
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        fetchRequest.predicate = predicate
        do {
            notesArray = try context.fetch(fetchRequest)
        } catch {
            fatalError("could not fetch")
        }
        print("count: \(notesArray.count)")
        
        for note in notesArray {
            print(note.text)
        }
        tableView.reloadData()
    }
    
    func delete(object: Note, indexPath: IndexPath) {
        print("count: \(notesArray.count)")
        do {
            try context.delete(object)
        } catch {
            fatalError("couldn't delete note")
        }
        
        do {
            try context.save()
        } catch {
            fatalError("couldn't save")
        }
        notesArray.remove(at: indexPath.row)
        //tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numofrowsinsec: \(notesArray.count)")
        return notesArray.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        delete(object: notesArray[indexPath.row], indexPath: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell") as! NotesCell
        print("called")
        cell.label.text = notesArray[indexPath.row].text
        print("text: \(cell.label.text)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteVC = storyboard?.instantiateViewController(withIdentifier: "NoteDetailVC") as! NoteDetailVC
        noteVC.note = notesArray[indexPath.row]
        noteVC.notebook = self.notebook
        self.present(noteVC, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: Any) {
        let noteVC = storyboard?.instantiateViewController(withIdentifier: "NoteDetailVC") as! NoteDetailVC
        noteVC.notebook = self.notebook
        self.present(noteVC, animated: true, completion: nil)
        print("back")
    }
    
}
