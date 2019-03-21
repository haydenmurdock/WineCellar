//
//  Detail&CreateVC.swift
//  WineCellar
//
//  Created by Hayden Murdock on 3/18/19.
//  Copyright © 2019 Hayden Murdock. All rights reserved.
//

import UIKit

class Detail_CreateVC: UIViewController {
    
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
            print("image has been passed along")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func sliderWasTapped(_ sender: UISlider) {
    ratingLabel.text = String(round(sender.value))
    }
    
    func checkForImage() {
        if wineImage != nil {
            wineImageOutlet.image = wineImage
        }
    }
}
