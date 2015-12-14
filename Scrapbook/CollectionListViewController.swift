//
//  CollectionListViewController.swift
//  Scrapbook
//
//  Created by Pamela Needle on 9/12/15.
//  Copyright (c) 2015 Pamela Needle. All rights reserved.
//

import UIKit

class CollectionListViewController: UITableViewController {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext
    
    //let model : ScrapbookModel = ScrapbookModel(object: managedObjectContext)
    var model : ScrapbookModel?
    var clippingsArray: [Clipping] = []
    var collectionsArray: [Collection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        model = ScrapbookModel(object: managedObjectContext)
        collectionsArray = model!.getAllCollections()
        clippingsArray = model!.getAllClippings()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return  1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return collectionsArray.count+1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("allClipsCell", forIndexPath: indexPath) 
            return cell
        } else{
        let cell = tableView.dequeueReusableCellWithIdentifier("collectionCell", forIndexPath: indexPath) 
            let collection = collectionsArray[indexPath.row-1] //either plus or minus one
            cell.textLabel!.text = collection.name
            return cell
        
        }

        
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        if(indexPath.row == 0){
            return false
        }
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            model!.deleteCollection(self.collectionsArray[indexPath.row-1])
            collectionsArray.removeAtIndex(indexPath.row-1)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // inserted functionality implemented separately
            
        
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
       if segue.identifier == "showClips"{
            if let destination = segue.destinationViewController as? ClippingListViewController{
                if let collectionIndex = tableView.indexPathForSelectedRow?.row {
                    //println(collectionIndex)
                    destination.currentCollection = collectionsArray[collectionIndex-1]
                    //println(collectionsArray[collectionIndex-1].name)
                    destination.model = model
                }
                
            }
        }
        if segue.identifier == "showAllClips"{
            if let destination = segue.destinationViewController as? ClippingListViewController{
                destination.currentCollection = nil
                destination.model = model
            }
        }

        
    }
    
    
    @IBAction func createCollectionClicked(sender: AnyObject) {
        var inputTextField: UITextField?
        let alert = UIAlertController(title: "Create a new Collection", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            //var enteredText = ((alert.textFields?.first)!).text
            var inputText = "Unknown Collection"
            if let firstText = alert.textFields?.first {
                if let enteredText = firstText.text{
                    if enteredText.characters.count > 0 {
                        inputText = enteredText
                    }
                }
                
            }
//            if enteredText.characters.count == 0 {
//                enteredText = "Unknown Collection"
//            }
            let newCol = self.model!.newCollection(inputText)
            self.collectionsArray.append(newCol)
            self.tableView.reloadData()
        }))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Enter Collection name"
            //textField.secureTextEntry = true
            inputTextField = textField
        })
        
        presentViewController(alert, animated: true, completion: nil)
        //self.tableView.reloadData()

    }
    

}
