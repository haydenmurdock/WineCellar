//
//  Detail&CreateVC.swift
//  WineCellar
//
//  Created by Hayden Murdock on 3/18/19.
//  Copyright © 2019 Hayden Murdock. All rights reserved.
//

import UIKit

class Detail_CreateVC: UIViewController {
    
    var wineImage: UIImage?{
        didSet{
            print("image has been passed along")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
