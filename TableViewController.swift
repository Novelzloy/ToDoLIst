//
//  TableViewController.swift
//  ToDoList
//
//  Created by Роман on 07.05.2021.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var tasks: [Task] = []
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Task", message: "Please add new Task", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let tf = alertController.textFields?.first
            if let newTacksTitle = tf?.text{
                self.saveTask(withTitle: newTacksTitle)
                self.tableView.reloadData()
            }
        }
        
        
        alertController.addTextField { _ in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    private func saveTask(withTitle title: String){
        let context = getContext()
        
        guard let entity  = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = title
        
        do {
            try context.save()
            tasks.append(taskObject)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    @IBAction func deliteAll(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Записей больше нет", message: "При следующем запуске приложения все ваши задания будут удалены", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Отлично!", style: .default) { _ in }
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        if let objects = try? context.fetch(fetchRequest){
            for object in objects {
                context.delete(object)
            }
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let sorteDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sorteDescriptor]
        
        do {
            try tasks = context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title

        return cell
    }

    
}
