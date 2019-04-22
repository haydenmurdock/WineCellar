//
//  QuoteViewController.swift
//  WineCellar
//
//  Created by Hayden Murdock on 4/22/19.
//  Copyright © 2019 Hayden Murdock. All rights reserved.
//

import UIKit

class QuoteViewController: UIViewController {

    @IBOutlet weak var quoteTextView: UITextView!
    
    var quotes: [Quote] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        QuoteController.shared.fetchQuote { (quote) in
            if let quote = quote {
                DispatchQueue.main.async {
                    self.quoteTextView.text = ("\(quote.quote)- Kanye West")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
          self.performSegue(withIdentifier: "toUserCheckNavigationContoller", sender: self)
        })
    }
}
