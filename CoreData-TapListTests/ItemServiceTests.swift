//
//  ItemServiceTests.swift
//  CoreData-TapList
//
//  Created by zklgame on 7/4/16.
//  Copyright © 2016 Zhejiang University. All rights reserved.
//

import XCTest
import CoreData
import CoreData_TapList

class ItemServiceTests: XCTestCase {
    
    var itemService: ItemService!
    var coreDataStack: CoreDataStack!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        coreDataStack = TestCoreDataStack()
        itemService = ItemService(managedObjectContext: coreDataStack.managedObjectContext)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        itemService = nil
        coreDataStack = nil
    }

    func testAddItem() {
        let item = itemService.addItem("item1", score: 30)
        XCTAssertNotNil(item, "item should not be nil")
        XCTAssertTrue(item.name == "item1")
        XCTAssertTrue(item.score!.integerValue == 30)
    }
    
    func testContextIsSavedAfterAddingItem() {
        expectationForNotification(NSManagedObjectContextDidSaveNotification, object: coreDataStack.managedObjectContext) { (notification) -> Bool in
            return true
        }
        
        itemService.addItem("item1", score: 1)
        
        waitForExpectationsWithTimeout(2.0) { (error) in
            XCTAssertNil(error, "Save did not occur")
        }
    }

}
