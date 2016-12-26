//
//  NoteDetailVC.swift
//  learning coredata
//
//  Created by Harry Merzin on 12/24/16.
//  Copyright © 2016 Harry Merzin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NoteDetailVC: UIViewController {
    var note: Note?
    var notebook: Notebook?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var noteTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(note != nil) {
            noteTextField.text = note?.text
        }
        noteTextField.contentVerticalAlignment = .top
    }
    
    @IBAction func back(_ sender: Any) {
        if(note != nil) {
            note?.text = noteTextField.text
        } else {
            let object = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Note", in: context)!, insertInto: context) as! Note
            object.text = noteTextField.text
            object.notebook = self.notebook
        }
        do {
            try context.save()
        } catch {
            fatalError("couldn't save context")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
