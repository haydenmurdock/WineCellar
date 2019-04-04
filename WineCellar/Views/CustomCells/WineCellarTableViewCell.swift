//
//  WineCellarTableViewCell.swift
//  WineCellar
//
//  Created by Hayden Murdock on 4/1/19.
//  Copyright © 2019 Hayden Murdock. All rights reserved.
//

import UIKit

class WineCellarTableViewCell: UITableViewCell {

    @IBOutlet weak var wineNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var wineImage: UIImageView!
    
    var wine: Wine?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func updateViews(with Wine: Wine) {
    guard let wine = wine, let image = wine.picture else {
    return
    }
        wineNameLabel.text = wine.name
        ratingLabel.text = wine.rating
        notesTextView.text = wine.notes
        wineImage.image = UIImage(data: image)
    }
}
