//
//  CustomViewButton.swift
//  WineCellar
//
//  Created by Hayden Murdock on 4/4/19.
//  Copyright © 2019 Hayden Murdock. All rights reserved.
//

import UIKit

class CustomViewButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpButton()
    }
    
    private func setUpButton() {
        backgroundColor = UIColor(displayP3Red: 230/255, green: 75/255, blue: 95/255, alpha: 1)
       layer.cornerRadius = frame.size.height/2
    }
}
