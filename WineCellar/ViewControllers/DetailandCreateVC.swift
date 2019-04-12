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
    @IBOutlet weak var pairsWellWithTextView: UITextView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var wineRatingSlider: UISlider!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addPhotoButton: CustomViewButton!
    
    var wine: Wine?
    
    var wineImage: UIImage?{
        didSet{
            print("image has been passed along. \(String(describing: self.wineImage))")
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateView()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func sliderWasTapped(_ sender: UISlider) {
        ratingLabel.text = ("Rating: \(String(round(sender.value)))")
    }
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let wineName = wineNameTextField.text, let rating = ratingLabel.text, let producer = producerTextField.text, let pairsWithText = pairsWellWithTextView.text, let notes = notesTextView.text, let image = wineImageOutlet.image else {
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
    
    func getWineColorIndex(wine: Wine)->Int{
        if wine.color == "Red"{
            return 0
        } else if wine.color == "White"{
            return 1
        } else {
            return 2
        }
    }
    
    func updateView() {
        notesTextView.addDoneButtonOnKeyboard()
        notesTextView.delegate = self
        pairsWellWithTextView.addDoneButtonOnKeyboard()
        wineNameTextField.addDoneButtonOnKeyboard()
        producerTextField.addDoneButtonOnKeyboard()
        
        
        if wineImage != nil {
            wineImageOutlet.image = wineImage
            addPhotoButton.isHidden = true
            
        }
        if wine != nil {
            guard let wine = wine,let picture = wine.picture, let rating = wine.rating, let ratingSlider = Float(rating) else {
                print("wine isn't here")
                return
            }
            let wineColorIndex = getWineColorIndex(wine: wine)
            colorSegmentController.selectedSegmentIndex = wineColorIndex
            ratingLabel.text = "Rating: \(rating)"
            wineNameTextField.text = wine.name
            producerTextField.text = wine.producer
            pairsWellWithTextView.text = wine.pairsWellWith
            notesTextView.text = wine.notes
            wineRatingSlider.value = ratingSlider
            wineImageOutlet.image = UIImage(data: picture)
            wineImage = UIImage(data: picture)
            addPhotoButton.isHidden = true
    
        }
    }

    @IBAction func saveButtonTouched(_ sender: Any) {
        let color = checkWineColor(wineColorIndex: colorSegmentController.selectedSegmentIndex)
        guard let image = wineImage,  let name = wineNameTextField.text else {
            showAlertController()
            return
        }
        let rating = ratingLabel.text ?? ""
        let notes = notesTextView.text ?? ""
        let producer = producerTextField.text ?? ""
        let pairsWellWith = pairsWellWithTextView.text ?? ""
        
        if wine == nil{
            WineController.shared.createWine(name: name, color: color, notes: notes, pairsWellWith: pairsWellWith, picture: image, producer: producer, rating: rating)
        } else {
            guard let wineToUpdate = wine, let wineDataImage = image.pngData() else {
                return
            }
            WineController.shared.updateWine(wineToUpdate: wineToUpdate, name: name, color: color, notes: notes, pairsWellWith: pairsWellWith, picture: wineDataImage, producer: producer, rating: rating)
        }
        navigationController?.popToRootViewController(animated: true)
    }
    func showAlertController() {
        let alertController = UIAlertController(title: "", message: "Make sure your wine has a picture and a name ", preferredStyle: .alert)
        
        let cancelActionItem = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelActionItem)
        
        present(alertController, animated: true)
        
    }
}

extension DetailandCreateVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.tag == 1 {
    self.view.frame.origin.y -= 125
        print("View was moved up 125")
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 1 {
            self.view.frame.origin.y += 125
            print("View was moved down 125")
        }
    }
}
