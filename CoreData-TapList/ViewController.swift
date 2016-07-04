//
//  ViewController.swift
//  CoreData-TapList
//
//  Created by zklgame on 6/29/16.
//  Copyright © 2016 Zhejiang University. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.coreDataStack.managedObjectContext
    }()
    
    var fetchedResultsController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = CGFloat(76)
        self.tableView.rowHeight = CGFloat(76)
        
        let fetchRequest = NSFetchRequest(entityName: "Item")
        let sortDescriptor = NSSortDescriptor(key: "score", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error: \(error.userInfo)")
        }
    }
    
    @IBAction func addItem() {
        let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action) in
            let nameField = alert.textFields![0]
            let scoreField = alert.textFields![1]
            
            let itemService = ItemService(managedObjectContext: self.context)
            itemService.addItem(nameField.text!, score: Int(scoreField.text!) ?? 0)
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "name"
        }
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "score"
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        cell.item = fetchedResultsController.objectAtIndexPath(indexPath) as? Item

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = fetchedResultsController.objectAtIndexPath(indexPath) as! Item
        let score = item.score!.integerValue
        item.score = NSNumber(integer: score + 1)
        
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Error: \(error.userInfo)")
        }
    }
    
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Update:
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! ItemCell
            cell.item = fetchedResultsController.objectAtIndexPath(indexPath!) as? Item
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}




