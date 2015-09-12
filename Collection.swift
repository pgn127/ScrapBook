//
//  Collection.swift
//  Scrapbook
//
//  Created by Pamela Needle on 9/7/15.
//  Copyright (c) 2015 Pamela Needle. All rights reserved.
//

import Foundation
import CoreData

class Collection: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var myClippings: NSSet

    func addClipping(clipping: Clipping){
        self.mutableSetValueForKey("myClippings").addObject(clipping)
    }
    
    
    
}
