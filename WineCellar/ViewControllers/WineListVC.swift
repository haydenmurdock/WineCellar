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
    @IBOutlet var collectionView: UIView!
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet var noItemsView: UIView!
    
    
    
    var wineImage: UIImage?
    var collectionViewShowing: Bool = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        checkForNoItemView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        collectionV.delegate = self
        collectionV.dataSource = self
        print("There are a total of \(WineController.shared.wines.count) amount of wines in Array")
        checkForNoItemView()
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
        
        if collectionViewShowing == false {
            self.view.addSubview(collectionView)
            collectionView.center = tableView.center
            collectionView.frame = tableView.frame
            collectionViewShowing = true
        } else {
            UIView.transition(with: collectionView,
                             duration: 2.0, options:
            [.transitionFlipFromLeft], animations:
           collectionView.removeFromSuperview) { (true) in
            self.collectionViewShowing = false
         
            }
        }
    }
}

extension WineListVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WineController.shared.wines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionV.dequeueReusableCell(withReuseIdentifier: "wineCollectionViewCell", for: indexPath) as? WineCellarCollectionViewCell else {
            return UICollectionViewCell()
        }
        let wine = WineController.shared.wines[indexPath.row]
        cell.wine = wine
        cell.updateView()
        cell.delegate = self 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = storyboard.instantiateViewController(withIdentifier: "detailAndCreateVC") as! DetailandCreateVC
        let wineToSend = WineController.shared.wines[indexPath.row]
        desVC.wine = wineToSend
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    func checkForNoItemView() {
        if WineController.shared.wines.count == 0 {
           
            noItemsView.frame = tableView.frame
            noItemsView.center = tableView.center
            self.view.addSubview(noItemsView)
        }
    }
}


extension WineListVC: collectionViewDelegate{
    func deleteWineOnCell(_ cell: WineCellarCollectionViewCell) {
        guard let wineToDelete = cell.wine, let wineName = wineToDelete.name else {
            return
        }
        
            let alertController = UIAlertController(title: "", message: "Do you want to delete \(wineName)", preferredStyle: .alert)
            
            let deleteActionItem = UIAlertAction(title: "Delete", style: .default) { (_) in
                
                let indexToDelete = WineController.shared.removeWineReturnIndex(enteredWine: wineToDelete)
                
                let indexPath = IndexPath(row: indexToDelete, section: 0)
                
                self.collectionV.performBatchUpdates({
                    self.collectionV.deleteItems(at: [indexPath])
                }) { (finished) in
                    self.collectionV.reloadData()
                }
            }
            let cancelActionItem = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(deleteActionItem)
            alertController.addAction(cancelActionItem)
            
            present(alertController, animated: true)
    }
}
