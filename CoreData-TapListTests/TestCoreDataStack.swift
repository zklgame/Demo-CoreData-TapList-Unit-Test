//
//  TestCoreDataStack.swift
//  CoreData-TapList
//
//  Created by zklgame on 7/4/16.
//  Copyright © 2016 Zhejiang University. All rights reserved.
//

import Foundation
import CoreData
import CoreData_TapList

class TestCoreDataStack: CoreDataStack {

    override init() {
        super.init()
        
        self.persistentStoreCoordinator = {
            let psc = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            
            do {
                try psc.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
            } catch let error as NSError {
                print("ERROR: \(error.userInfo)")
            }
            
            return psc
        }()
    }
}