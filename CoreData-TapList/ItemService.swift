//
//  ItemService.swift
//  CoreData-TapList
//
//  Created by zklgame on 7/4/16.
//  Copyright © 2016 Zhejiang University. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class ItemService {
    let managedObjectContext: NSManagedObjectContext
    
    public init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    public func addItem(name: String, score: NSNumber) -> Item {
        let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: self.managedObjectContext) as! Item
        item.name = name
        item.score = score
        item.image = UIImage(named: "meow")
        
        do {
            try self.managedObjectContext.save()
        } catch let error as NSError {
            print("Error: \(error.userInfo)")
        }
        
        return item
    }

}