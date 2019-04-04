//
//  WineListVC.swift
//  WineCellar
//
//  Created by Hayden Murdock on 3/21/19.
//  Copyright © 2019 Hayden Murdock. All rights reserved.
//

import UIKit

class WineListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var tableView: UITableView!
    
    var wineImage: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        print("There are a total of \(WineController.shared.wines.count) amount of wines in Array")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WineController.shared.wines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WineTableViewCell", for: indexPath) as? WineCellarTableViewCell else {
            return UITableViewCell ()
        }
        let wine = WineController.shared.wines[indexPath.row]
        cell.wine = wine
        cell.updateViews(with: wine)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let wineToDelete = WineController.shared.wines[indexPath.row]
        WineController.shared.removeWine(enteredWine: wineToDelete)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailFromTableViewCell" {
            guard let destinationVC = segue.destination as? DetailandCreateVC,
                let index = tableView.indexPathForSelectedRow else {
                    return
            }
                let wine = WineController.shared.wines[index.row]
                destinationVC.wine = wine
        }
    }
   
    @IBAction func switchTapped(_ sender: UISwitch) {
        print("switch was tapped")
       // performSegue(withIdentifier: "showCollectionView", sender: self)
    }
}
