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
    
    func getAllClippings() -> [Clipping] {
        var error: NSError?
        var clippingArray: [Clipping] = []
        let fetchRequest = NSFetchRequest(entityName: "Clipping")
        let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [Clipping]
        
        if let clippings = fetchResults{
            clippingArray = clippings
        }else{
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        return clippingArray
        //return collectionArray
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
    }
    
    func newClipping(notes: String, image: UIImage) -> Clipping{
        let entityDescription = NSEntityDescription.entityForName("Clipping",inManagedObjectContext: managedObjectContext!)
        var newClip = Clipping(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        newClip.notes = notes
        //newClip.image = image
        newClip.dateCreated = NSDate()
        let documentsFolder: String = NSSearchPathForDirectoriesInDomains( .DocumentDirectory, .UserDomainMask, true)[0] as! String
        newClip.image = "/\(newClip.dateCreated).jpg"
        let documentPath = documentsFolder + newClip.image
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        imageData.writeToFile(documentPath, atomically: true)
        saveObj()
        
        return newClip
    }
    
    
    
    func addClippingtoCollection(clipping: Clipping, collection: Collection ) {
        //let entityDescription = NSEntityDescription.entityForName("Collection",inManagedObjectContext: managedObjectContext!)
        collection.addClipping(clipping)
        clipping.myCollection = collection
        
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
        for clipping in collection.myClippings{
            managedObjectContext!.deleteObject(clipping as! NSManagedObject)
        }
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
    
    func searchClippingsWithin(match: String, collection: Collection) -> [Clipping]{
        let request = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Clipping",
            inManagedObjectContext: managedObjectContext!)
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "notes contains[c] %@", match)
        let pred2 = NSPredicate(format: "myCollection == %@", collection)
        let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [pred, pred2])
        request.predicate = predicate
        
        var error: NSError?
        var results = managedObjectContext?.executeFetchRequest(request,
            error: &error)
        return results as! [Clipping]
    }
    
   
}
