//
//  ViewController.swift
//  Scrapbook
//
//  Created by Pamela Needle on 8/30/15.
//  Copyright (c) 2015 Pamela Needle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var model = ScrapbookModel(object: managedObjectContext)
        //create 2 collections a and b
        var collectiona: Collection = model.newCollection("A")
        var collectionb: Collection = model.newCollection("B")
        
        //create 3 clippings
        var clipping1: Clipping = model.newClipping("1 foo",image: UIImage(named: "question")!)
        var clipping2: Clipping = model.newClipping("2 foo",image: UIImage(named: "question")!)
        var clipping3: Clipping = model.newClipping("3 bar",image: UIImage(named: "question")!)
        var testclippings:[Clipping] = [clipping1,clipping2,clipping3]
        
        //print list of all colelctions
        var collections = model.getAllCollections()
        for collection in collections {
            println(collection.name)
        }
        
        //print list of all clippings
        for clipping in testclippings {
            println("note value: \(clipping.notes)"+"image path: \(clipping.image)"+"   date created: \(clipping.dateCreated)")
        }
        
        //add clipping 1 and 2 to collection a
        model.addClippingtoCollection(clipping1, collection: collectiona)
        model.addClippingtoCollection(clipping2, collection: collectiona)
        
        //print all clippings in collection a
        println("IN Collection A before deletion")
        for clipping in collectiona.myClippings{
            var currentclipping = clipping as! Clipping
            println("note value: \(currentclipping.notes)"+"image path: \(currentclipping.image)"+"   date created: \(currentclipping.dateCreated)")
        }
        println("")
        
        //delete clipping 1
        model.deleteClipping(clipping1)
        
        //print all clippings in collection a
        println("IN Collection A after deletion")
        for clipping in collectiona.myClippings{
            var currentclipping = clipping as! Clipping
            println("note value: \(currentclipping.notes)"+"image path: \(currentclipping.image)"+"   date created: \(currentclipping.dateCreated)")
        }
        
        
        //search and print all clippings that contain search term "bar"
        println("searched results:")
        var results = model.searchClippings("bar")
        for result in results {
            println("note value: \(result.notes)"+"image path: \(result.image)"+"   date created: \(result.dateCreated)")
        }
        //print(managedObjectContext)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

