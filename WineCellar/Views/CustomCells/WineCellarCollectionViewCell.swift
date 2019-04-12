//
//  WineCellarCollectionViewCell.swift
//  WineCellar
//
//  Created by Hayden Murdock on 4/4/19.
//  Copyright © 2019 Hayden Murdock. All rights reserved.
//

import UIKit

class WineCellarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var wineNameLabel: UILabel!
    @IBOutlet weak var wineImage: UIImageView!
    
    var wine: Wine?
    
   func updateView() {
    guard let picture = wine?.picture else {
        return
    }
    wineNameLabel.text = wine?.name
    let image = UIImage(data: picture)
    wineImage.image = image
    }
}
