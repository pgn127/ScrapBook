//
//  ClippingListViewController.swift
//  Scrapbook
//
//  Created by Pamela Needle on 9/13/15.
//  Copyright (c) 2015 Pamela Needle. All rights reserved.
//

import UIKit

class ClippingListViewController: UITableViewController, UISearchResultsUpdating {

    
    var currentCollection: Collection?
    var model : ScrapbookModel?
    var displayedClippings: [Clipping] = []
    var searchedClips: [Clipping] = []
    var resultSearchController = UISearchController()
    
    @IBOutlet weak var addbutton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //if a collection was selected in past screen show the clippings of that colleciton
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.setRightBarButtonItems([addbutton,self.editButtonItem()], animated: true)
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let collection = currentCollection {
            let arrayClippings = collection.myClippings.allObjects as NSArray
            displayedClippings = arrayClippings as! [Clipping]
            self.navigationItem.title = collection.name
        }
            
            //if all clippings were selected show all clipppings
        else{
            displayedClippings = model!.getAllClippings()
            self.navigationItem.title = "All Clippings"
        }
        
        tableView.reloadData()

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
        if (self.resultSearchController.active) {
            return self.searchedClips.count
        }
        else {
            return self.displayedClippings.count
        }
        //return displayedClippings.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("clippingCell", forIndexPath: indexPath) 
            //cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "qrCell")
        var clipping: Clipping?
        
        if (self.resultSearchController.active) {
            clipping = searchedClips[indexPath.row]
        }
        else{
            clipping = displayedClippings[indexPath.row]
        }
        let clipImg = cell.contentView.viewWithTag(1) as! UIImageView
//        if let provided = clipping.image {
        let documentsFolder: String = NSSearchPathForDirectoriesInDomains( .DocumentDirectory, .UserDomainMask, true)[0] 
        let documentPath = documentsFolder + "/\(clipping!.dateCreated).jpg"
        clipImg.image = UIImage(contentsOfFile: documentsFolder+clipping!.image)
        let noteLabel = cell.contentView.viewWithTag(3) as! UILabel
        let dateLabel = cell.contentView.viewWithTag(2) as! UILabel
        noteLabel.text = clipping!.notes
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateLabel.text = dateFormatter.stringFromDate(clipping!.dateCreated)
        //dateLabel.text = "\(clipping!.dateCreated)"
        // Configure the cell...
        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        searchedClips.removeAll(keepCapacity: false)
        if let insideCollection = currentCollection{
            searchedClips = model!.searchClippingsWithin(searchController.searchBar.text!, collection: insideCollection)
            //println("performing search within a collection")
        }
        else{
            searchedClips = model!.searchClippings(searchController.searchBar.text!)
            //println("performing search of all clippings")
        }
        
        self.tableView.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            model!.deleteClipping(self.displayedClippings[indexPath.row])
            displayedClippings.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
//    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
//        if let insideCollection = currentCollection{
//            searchedClips = model!.searchClippingsWithin(searchString, collection: insideCollection)
//        }
//        else{
//            searchedClips = model!.searchClippings(searchString)
//        }
//        return true
//    }
//    
//    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
//        if let insideCollection = currentCollection{
//            searchedClips = model!.searchClippingsWithin(self.searchDisplayController!.searchBar.text, collection: insideCollection)
//        }
//        else{
//            searchedClips = model!.searchClippings(self.searchDisplayController!.searchBar.text)
//        }
//        return true
//    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            if let destination = segue.destinationViewController as? ClippingDetailViewController {
                if let clippingIndex = tableView.indexPathForSelectedRow?.row {
            
                    let currentclipping = displayedClippings[clippingIndex]
                    //destination.loadView()
                    let documentsFolder: String = NSSearchPathForDirectoriesInDomains( .DocumentDirectory, .UserDomainMask, true)[0]
                    destination.imagevar = UIImage(contentsOfFile: documentsFolder+currentclipping.image)
                    destination.notesvar = currentclipping.notes
                    destination.datevar = "\(currentclipping.dateCreated)"
                }
            }
            
        }
        if segue.identifier == "addClipping" {
            let vC = segue.destinationViewController as! UINavigationController
            let dest = vC.viewControllers.first as! CreateClippingViewController
            dest.model = self.model
            if let notAll = currentCollection{
                dest.inCollection = notAll
                
            }
            else {
                dest.inCollection = nil
                
            }
            
        }
    

    }
}
