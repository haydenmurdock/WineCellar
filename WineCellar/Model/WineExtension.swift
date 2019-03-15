//
//  WineExtension.swift
//  WineCellar
//
//  Created by Hayden Murdock on 3/15/19.
//  Copyright © 2019 Hayden Murdock. All rights reserved.
//

import Foundation
import CoreData

extension Wine {
    convenience init(name: String, color: String, notes: String, pairsWellWith: String, picture: Data, producer: String, rating: Double, context: NSManagedObjectContext = CoreDataStack.context){
        
        self.init(context: context)
        
        self.name = name
        self.color = color
        self.notes = notes
        self.pairsWellWith = pairsWellWith
        self.picture = picture
        self.producer = producer
        self.rating = rating
        
    }
}
