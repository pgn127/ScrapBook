//
//  ClippingListViewController.swift
//  Scrapbook
//
//  Created by Pamela Needle on 9/13/15.
//  Copyright (c) 2015 Pamela Needle. All rights reserved.
//

import UIKit

class ClippingListViewController: UITableViewController {

    
    var currentCollection: Collection?
    var model : ScrapbookModel?
    var displayedClippings: [Clipping] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //if a collection was selected in past screen show the clippings of that colleciton
        
        if let collection = currentCollection {
            displayedClippings = collection.myClippings.allObjects as! [Clipping]
            self.navigationItem.title = collection.name
        }
        
         //if all clippings were selected show all clipppings
        else{
            displayedClippings = model!.getAllClippings()
            self.navigationItem.title = "All Clippings"
        }

        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return displayedClippings.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("clippingCell", forIndexPath: indexPath) as! UITableViewCell
            //cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "qrCell")
        let clipping = displayedClippings[indexPath.row]
        var clipImg = cell.contentView.viewWithTag(1) as! UIImageView
//        if let provided = clipping.image {
        clipImg.image = UIImage(data: clipping.image as NSData)
//        }
//        else{
//            clipImg.image = UIImage(named: "question")
//        }
        
        //cell.img.image = UIImage(data: clipping.image as NSData)
        var noteLabel = cell.contentView.viewWithTag(3) as! UILabel
        var dateLabel = cell.contentView.viewWithTag(2) as! UILabel
        noteLabel.text = clipping.notes
        dateLabel.text = "\(clipping.dateCreated)"
        // Configure the cell...
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        if let destination = segue.destinationViewController as? ClippingDetailViewController{
            if let clippingIndex = tableView.indexPathForSelectedRow()?.row {
            
                var currentclipping = displayedClippings[clippingIndex]
                
                destination.img.image = UIImage(data: currentclipping.image as NSData)
                destination.notes.text = currentclipping.notes
                destination.date.text = "\(currentclipping.dateCreated)"
            }
            
    }
    

}
}
