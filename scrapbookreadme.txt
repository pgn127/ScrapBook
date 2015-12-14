Assignment 2 Readme
Pamela Needle

Part 1: Testing your database
Here is my code from my original viewcontroller 
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

Here is the output of the tests when i run the app:
A
B
note value: 1 fooimage path: /2015-09-14 08:18:22 +0000.jpg   date created: 2015-09-14 08:18:22 +0000
note value: 2 fooimage path: /2015-09-14 08:18:22 +0000.jpg   date created: 2015-09-14 08:18:22 +0000
note value: 3 barimage path: /2015-09-14 08:18:22 +0000.jpg   date created: 2015-09-14 08:18:22 +0000
IN Collection A before deletion
note value: 2 fooimage path: /2015-09-14 08:18:22 +0000.jpg   date created: 2015-09-14 08:18:22 +0000
note value: 1 fooimage path: /2015-09-14 08:18:22 +0000.jpg   date created: 2015-09-14 08:18:22 +0000

IN Collection A after deletion
note value: 2 fooimage path: /2015-09-14 08:18:22 +0000.jpg   date created: 2015-09-14 08:18:22 +0000
searched results:
note value: 3 barimage path: /2015-09-14 08:18:22 +0000.jpg   date created: 2015-09-14 08:18:22 +0000


Design:
I started off with the navigation controller as the entry point since the collection, clipping and clipping detail view controllers all are to be pushed onto a stack and retrieved as so.  In my collection list view controller i have the All clippings cell as non editable so that the user will always be able to view the all clippings table view, i set up a segue from the all clippings cell to the clipping list view controller and another segue from any of the collection cells to that same clippings cell view controller. Depending on which cell was clicked, the app will identify the segue identifier so it will know what data to display in the clipping list view controller. The add button in the clipping list view controller has a modal segue to another navigation controller which will ultimately lead to the create clipping view controller because i Chose to embed the createclippingviewcontroller so that a navigation bar will keep consistency throughout the app (for users sake)
I presented modally instead of push bc adding item is modal operation since the action is self contained.
From the create new clipping view controller i se it so that the save and cancel button perform respective actions and then ultimately dismiss that view controller leading you back to the clipping list view controller. The final segue is from the clipping list view controller cells that lead to the clipping detail view controller through a push segue. 
I decided to have a large space for text so that this scrapbook can be used for things such as recipes and longer notes


I used these sources when creating my project:

http://www.ioscreator.com/tutorials/add-search-table-view-tutorial-ios8-swift
http://www.techotopia.com/index.php/Accessing_the_iOS_8_Camera_and_Photo_Library_in_Swift
