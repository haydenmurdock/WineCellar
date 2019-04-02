//
//  WineController.swift
//  WineCellar
//
//  Created by Hayden Murdock on 3/15/19.
//  Copyright © 2019 Hayden Murdock. All rights reserved.
//

import UIKit
import CoreData

class WineController {
    
    //CRUD AND WINE ARRAY
    
    static let shared = WineController()
    
    var wines: [Wine] = []
    
    func createWine(name: String, color: String, notes: String, pairsWellWith: String, picture: UIImage, producer: String, rating: String){
        
        let createdWine = Wine(name: name, color: color, notes: notes, pairsWellWith: pairsWellWith, picture: picture, producer: producer, rating: rating)
        
        print("\(String(describing: createdWine.name)) has been created and Added to Wines Array")
        
        wines.append(createdWine)
        
        CoreDataStack.saveContext()
    }
    
    func removeWine(enteredWine: Wine) {
        for (index,wine) in wines.enumerated(){
            if wine == enteredWine {
                print("\(String(describing: enteredWine.name)) is being removed at \(index)")
                wines.remove(at: index)
                CoreDataStack.context.delete(enteredWine)
                CoreDataStack.saveContext()
            }
        }
    }
    
    func updateWine(wineToUpdate: Wine, name: String, color: String, notes: String, pairsWellWith: String, picture: Data, producer: String, rating: String){
        
        wineToUpdate.setValue(name, forKey: "name")
        wineToUpdate.setValue(color, forKey: "color")
        wineToUpdate.setValue(notes, forKey: "notes")
        wineToUpdate.setValue(pairsWellWith, forKey: "pairsWellWith")
        wineToUpdate.setValue(picture, forKey: "picture")
        wineToUpdate.setValue(producer, forKey: "producer")
        wineToUpdate.setValue(rating, forKey: "rating")
        
        print("Wine has been updated")
        
        CoreDataStack.saveContext()
    }
    
    func fetchAllItems() -> [Wine]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Wine")
        
        let results = try? CoreDataStack.context.fetch(fetchRequest)
        print("Wines were fetched from CoreData")
        return results as? [Wine]
    }
}


