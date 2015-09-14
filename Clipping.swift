//
//  Clipping.swift
//  Scrapbook
//
//  Created by Pamela Needle on 9/7/15.
//  Copyright (c) 2015 Pamela Needle. All rights reserved.
//

import Foundation
import CoreData

class Clipping: NSManagedObject {

    @NSManaged var image: String
    @NSManaged var notes: String
    @NSManaged var dateCreated: NSDate
    @NSManaged var myCollection: Collection?

}
