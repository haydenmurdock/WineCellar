//
//  WineCellarCollectionViewCell.swift
//  WineCellar
//
//  Created by Hayden Murdock on 4/4/19.
//  Copyright © 2019 Hayden Murdock. All rights reserved.
//

import UIKit

protocol collectionViewDelegate: class {
    func deleteWineOnCell(_ cell: WineCellarCollectionViewCell)
}

class WineCellarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var wineNameLabel: UILabel!
    @IBOutlet weak var wineImage: UIImageView!
    
    var wine: Wine?
    weak var delegate: collectionViewDelegate?
    
    
   func updateView() {
    guard let picture = wine?.picture else {
        return
    }
    wineNameLabel.text = wine?.name
    let image = UIImage(data: picture)
    wineImage.image = image
    }
    @IBAction func deleteButtonPressed(_ sender: Any) {
        delegate?.deleteWineOnCell(self)
        print("button pressed")
    }
}
