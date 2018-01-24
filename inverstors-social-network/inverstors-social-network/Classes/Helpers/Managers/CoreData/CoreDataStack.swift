//
//  CoreDataStack.swift
//  inverstors-social-network
//
//  Created by D. on 2018-01-20.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import Foundation
import CoreData

private let CODEDATA_FILE_NAME = "inverstors_social_network"

class CoreDataStack {
    
    class func shared() -> CoreDataStack {
        struct Static {
            static let instance = CoreDataStack()
        }
        return Static.instance
    }
    
    var managedContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CODEDATA_FILE_NAME)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext(){
        //Save Data
        do {
            try self.managedContext.save()
        } catch let error as NSError {
            print("Error: unable to save data: \(error.localizedDescription)")
        }
    }
    
    func deleteAllRecords() {
        //Flush Data Baser
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "StockQuotePeriod")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch {
            print ("There was an error")
        }
    }
}
