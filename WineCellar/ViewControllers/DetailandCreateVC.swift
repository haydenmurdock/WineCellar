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
        updateView()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if wineImage != nil {
            wineImageOutlet.image = wineImage
        }
        if wine != nil {
            guard let wine = wine,let picture = wine.picture else {
                return
            }
            let wineColorIndex = getWineColorIndex(wine: wine)
            colorSegmentController.selectedSegmentIndex = wineColorIndex
            ratingLabel.text = wine.rating
            wineNameTextField.text = wine.name
            producerTextField.text = wine.producer
            pairsWellWithTextVIew.text = wine.pairsWellWith
            notesTextView.text = wine.notes
            wineImageOutlet.image = UIImage(data: picture)
            wineImage = UIImage(data: picture)
        }
    }

    @IBAction func saveButtonTouched(_ sender: Any) {
        let color = checkWineColor(wineColorIndex: colorSegmentController.selectedSegmentIndex)
        print("save Button Touched")
        guard let image = wineImage, let name = wineNameTextField.text,let rating = ratingLabel.text, let notes = notesTextView.text, let producer = producerTextField.text, let pairsWellWith = pairsWellWithTextVIew.text else {
            print("Information was missing and couldn't create Wine")
            return
        }
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
}

