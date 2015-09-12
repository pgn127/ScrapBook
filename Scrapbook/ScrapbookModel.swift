//
//  ScrapbookModel.swift
//  Scrapbook
//
//  Created by Pamela Needle on 9/7/15.
//  Copyright (c) 2015 Pamela Needle. All rights reserved.
//

import UIKit
import CoreData


class ScrapbookModel {
    //keep array of collections?
    var collectionArray: [Collection] = []
    var managedObjectContext: NSManagedObjectContext?
    
    init(object: NSManagedObjectContext?){
        managedObjectContext = object
    }
    
    func saveObj(){
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            println("there was an error saving object")
        }
    }
    
    func newCollection(name: String) -> Collection{
        let entityDescription = NSEntityDescription.entityForName("Collection",inManagedObjectContext: managedObjectContext!)
        var newCol = Collection(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        newCol.name = name
        //collectionArray.append(newCol)
        saveObj()
        return newCol
    }
    
    func getAllCollections() -> [Collection] {
        var error: NSError?
        let fetchRequest = NSFetchRequest(entityName: "Collection")
        let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [Collection]
        
        if let collections = fetchResults{
            collectionArray = collections
        }else{
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        return collectionArray
        //return collectionArray
    }
    
    func newClipping(notes: String, image: NSData) -> Clipping{
        let entityDescription = NSEntityDescription.entityForName("Clipping",inManagedObjectContext: managedObjectContext!)
        var newClip = Clipping(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        newClip.notes = notes
        newClip.image = image
        newClip.dateCreated = NSDate()
        
        saveObj()
        
        return newClip
    }
    
    
    
    func addClippingtoCollection(clipping: Clipping, collection: Collection ) {
        //let entityDescription = NSEntityDescription.entityForName("Collection",inManagedObjectContext: managedObjectContext!)
        collection.addClipping(clipping)
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            println("there was an error adding clipping")
        }
        
        //will this change be made automatically in the collection array
//        var error: NSError?
//        let fetchRequest = NSFetchRequest(entityName: "Collection")
//        let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [Collection]
//        
//        if let collections = fetchResults{
//            let collection = collections[0]
//            collection.addClipping(clipping)
//            
//            if managedObjectContext!.save(&error){
//                println("clipping added")
//            }else{
//                println("Could not save \(error), \(error!.userInfo)")
//            }
//        }else{
//            println("Could not fetch \(error), \(error!.userInfo)")
//        }
    }
    
    func deleteCollection(collection: Collection){
        managedObjectContext!.deleteObject(collection)
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            println("there was an error deleting collection")
        }
//        var error: NSError?
//        let fetchRequest = NSFetchRequest(entityName: "Collection")
//        let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [Collection]
//        
//        if let collections = fetchResults{
//            collection = collections[0]
//            managedObjectContext!.deleteObject(collection)
//            
//            if managedObjectContext!.save(&error){
//                println("clipping added")
//            }else{
//                println("Could not save \(error), \(error!.userInfo)")
//            }
//        }else{
//            println("Could not fetch \(error), \(error!.userInfo)")
//        }
    }
    
    func deleteClipping(clipping: Clipping){
        managedObjectContext!.deleteObject(clipping)
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            println("there was an error deleting clipping")
        }
    }
    
    func searchClippings(match: String) -> [Clipping]{
        //var matchingClippings: [Clipping] = []
        let request = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Clipping",
            inManagedObjectContext: managedObjectContext!)
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "notes contains[c] %@", match)
        request.predicate = pred
        
        var error: NSError?
        var results = managedObjectContext?.executeFetchRequest(request,
            error: &error)
        return results as! [Clipping]
    }
    
//    func searchClippingsWithin(match: String, collection: Collection) -> [Clipping]{
//        
//    }
    
   
}
