//
//  Detail&CreateVC.swift
//  WineCellar
//
//  Created by Hayden Murdock on 3/18/19.
//  Copyright © 2019 Hayden Murdock. All rights reserved.
//

import UIKit

class DetailandCreateVC: UIViewController {
    
    @IBOutlet weak var wineImageOutlet: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var wineNameTextField: UITextField!
    @IBOutlet weak var colorSegmentController: UISegmentedControl!
    @IBOutlet weak var producerTextField: UITextField!
    @IBOutlet weak var pairsWellWithTextVIew: UITextView!
    @IBOutlet weak var notesTextView: UITextView!
    
    var wine: Wine?
    
    
    var wineImage: UIImage?{
        didSet{
            print("image has been passed along. \(String(describing: self.wineImage))")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let cameraVC = CameraPreviewVC()
        cameraVC.passPhotoDelegate = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cameraVC = CameraPreviewVC()
        cameraVC.passPhotoDelegate = self
    }

    @IBAction func sliderWasTapped(_ sender: UISlider) {
    ratingLabel.text = String(round(sender.value))
    }
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let wineName = wineNameTextField.text, let rating = ratingLabel.text, let producer = producerTextField.text, let pairsWithText = pairsWellWithTextVIew.text, let notes = notesTextView.text, let image = wineImageOutlet.image else {
        return
        }
        let wineColor = checkWineColor(wineColorIndex: colorSegmentController.selectedSegmentIndex)
        
        
        WineController.shared.createWine(name: wineName, color: wineColor, notes: notes, pairsWellWith: pairsWithText, picture: image, producer: producer, rating: rating)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func checkWineColor(wineColorIndex: Int) -> String {
        if wineColorIndex == 0 {
            return "Red"
        } else if wineColorIndex == 1 {
            return "White"
        } else {
            return "Sparkling"
        }
    }
    
}

extension DetailandCreateVC: PassPhotoDelegate {
    func passPhoto(photo: UIImage) {
        wineImageOutlet.image = photo
        print("This fuction ran")
    }
}
