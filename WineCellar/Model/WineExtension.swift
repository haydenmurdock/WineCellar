//
//  WineExtension.swift
//  WineCellar
//
//  Created by Hayden Murdock on 3/15/19.
//  Copyright © 2019 Hayden Murdock. All rights reserved.
//

import CoreData
import UIKit

extension Wine {
    convenience init(name: String, color: String, notes: String, pairsWellWith: String, picture: UIImage, producer: String, rating: Double, context: NSManagedObjectContext = CoreDataStack.context){
        
        self.init(context: context)
        
        self.name = name
        self.color = color
        self.notes = notes
        self.pairsWellWith = pairsWellWith
        self.picture =  picture.pngData()
        self.producer = producer
        self.rating = rating
        
    }
}
