//
//  UserCheckScreenVC.swift
//  WineCellar
//
//  Created by Hayden Murdock on 3/21/19.
//  Copyright © 2019 Hayden Murdock. All rights reserved.
//

import UIKit
import CoreData

class UserCheckScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchWine()
        nextVC()
    }
    
    func fetchWine() {
        
        guard let itemsFetched = WineController.shared.fetchAllItems() else {
            return
        }
        print("There are a total of \(itemsFetched.count) items fetched")
        for item in itemsFetched  {
                if WineController.shared.wines.contains(item) {
                    
                }else {
                    WineController.shared.wines.append(item)
            }
        }
    }
    
    func nextVC() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WineListVC") as! WineListVC
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
}

