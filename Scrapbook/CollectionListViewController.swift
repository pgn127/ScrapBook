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
            let cell = tableView.dequeueReusableCellWithIdentifier("allClipsCell", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
        else{
        let cell = tableView.dequeueReusableCellWithIdentifier("collectionCell", forIndexPath: indexPath) as! UITableViewCell
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
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//            var alert = UIAlertView()
//            alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
//            alert.title = "Enter Input"
//            //how do i implement functionality of these
//            alert.addButtonWithTitle("Create")
//            alert.addButtonWithTitle("Cancel")
//            alert.dismissWithClickedButtonIndex(1, animated: false)
//            let textField = alert.textFieldAtIndex(0)
//            textField!.placeholder = "Collection Name Here"
//            //textField.keyboardType =
//            alert.delegate = self
//            alert.show()
            
            var inputTextField: UITextField?
            let alert = UIAlertController(title: "Create a new Collection", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Create", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                // Now do whatever you want with inputTextField (remember to unwrap the optional)
                var newCol = self.model!.newCollection((alert.textFields?.first as! UITextField).text)
                self.collectionsArray.append(newCol)
                let cell = tableView.dequeueReusableCellWithIdentifier("collectionCell", forIndexPath: indexPath) as! UITableViewCell
                //let collection = self.collectionsArray[indexPath.row-1] //either plus or minus one
                cell.textLabel!.text = newCol.name
            }))
            alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.placeholder = "Enter Collection name"
                //textField.secureTextEntry = true
                inputTextField = textField
            })
            
            presentViewController(alert, animated: true, completion: nil)
            
        
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
        //let vC = segue.destinationViewController as! ClippingListViewController
        //let historyVC = segue.destinationViewController as! HistoryViewController
        //let historyVC = vC.viewControllers.first as! HistoryViewController
//        let index = self.tableView.indexPathForC
       if segue.identifier == "showClips"{
            if let destination = segue.destinationViewController as? ClippingListViewController{
                if let collectionIndex = tableView.indexPathForSelectedRow()?.row {
                    destination.currentCollection = collectionsArray[collectionIndex-1]
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

//        if let destination = segue.destinationViewController as? ClippingListViewController{
//            if let collectionIndex = tableView.indexPathForSelectedRow()?.row {
//                if collectionIndex == 0 {
//                    //show allclippings
//                    destination.currentCollection = nil
//                }
//                else{
//                    
//                    destination.currentCollection = collectionsArray[collectionIndex-1]
//                }
//                destination.model = model
//            }
//        }
        //historyVC.historyArray = questionresponses
        
    }
    
    
    @IBAction func createCollectionClicked(sender: AnyObject) {
        var inputTextField: UITextField?
        let alert = UIAlertController(title: "Create a new Collection", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            // Now do whatever you want with inputTextField (remember to unwrap the optional)
            var newCol = self.model!.newCollection((alert.textFields?.first as! UITextField).text)
            self.collectionsArray.append(newCol)
            self.tableView.reloadData()
//            let cell = tableView.dequeueReusableCellWithIdentifier("collectionCell", forIndexPath: indexPath) as! UITableViewCell
//            //let collection = self.collectionsArray[indexPath.row-1] //either plus or minus one
//            cell.textLabel!.text = newCol.name
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
