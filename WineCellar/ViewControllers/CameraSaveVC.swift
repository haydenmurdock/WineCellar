//
//  CameraSaveVC.swift
//  WineCellar
//
//  Created by Hayden Murdock on 3/29/19.
//  Copyright © 2019 Hayden Murdock. All rights reserved.
//

import UIKit



class CameraSaveVC: UIViewController {

 
    @IBOutlet weak var winePreviewImageView: UIImageView!
    
    var wineImage: UIImage?
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToDetailVC"{
            guard let destinationVC  = segue.destination as? DetailandCreateVC else{
                return
            }
            destinationVC.wineImage = wineImage
    
        }
      
    }
    
    
    func updateView() {
        self.winePreviewImageView.image = self.wineImage
       
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
      performSegue(withIdentifier: "backToDetailVC", sender: nil)
        
    }
}
