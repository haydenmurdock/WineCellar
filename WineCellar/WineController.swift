//
//  WineController.swift
//  WineCellar
//
//  Created by Hayden Murdock on 3/15/19.
//  Copyright © 2019 Hayden Murdock. All rights reserved.
//

import Foundation
import CoreData

class WineController {
    
    //CRUD AND WINE ARRAY
    
    static let wineController = WineController()
    
    var wines: [Wine] = []
    
    func createWine(name: String, color: String, notes: String, pairsWellWith: String, picture: Data, producer: String, rating: Double){
        
        let createdWine = Wine(name: name, color: color, notes: notes, pairsWellWith: pairsWellWith, picture: picture, producer: producer, rating: rating)
        
        wines.append(createdWine)
        
        CoreDataStack.saveContext()
    }
    
    func removeWine(enteredWine: Wine) {
        for (index,wine) in wines.enumerated(){
            if wine == enteredWine {
                print("\(String(describing: enteredWine.name)) is being removed at \(index)")
                wines.remove(at: index)
            }
        }
        CoreDataStack.context.delete(enteredWine)
    }
}

