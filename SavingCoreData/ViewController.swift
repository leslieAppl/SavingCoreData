//
//  ViewController.swift
//  SavingCoreData
//
//  Created by leslie on 10/2/19.
//  Copyright © 2019 leslie. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var people: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        people = try! PersistenceServer.context.fetch(fetchRequest)
    }

    @IBAction func addBtn() {
        let alert = UIAlertController(title: "Person Card", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name:"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Age:"
            textField.keyboardType = .numberPad
        }
        
        let action = UIAlertAction(title: "POST", style: .default) { (_) in
            let name = alert.textFields?.first?.text
            let age = alert.textFields?.last?.text
            
            let person = Person(context: PersistenceServer.context)
            person.name = name
            person.age = Int16(age!)!
            PersistenceServer.saveContext()
            
            self.people.append(person)
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = people[indexPath.row].name
        cell.detailTextLabel?.text = String(describing: people[indexPath.row].age)
        return cell
    }
}
