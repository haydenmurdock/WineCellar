//
//  QuoteController.swift
//  WineCellar
//
//  Created by Hayden Murdock on 4/22/19.
//  Copyright © 2019 Hayden Murdock. All rights reserved.

import UIKit

class QuoteController {
    
    static let shared = QuoteController()
    
    let urlString = URL(string: "https://api.kanye.rest/")!
    
    func fetchQuote(completetion: @escaping (Quote?)-> Void){
        
        let dataTask = URLSession.shared.dataTask(with: urlString) { (data, _, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let decodedQuote = try jsonDecoder.decode(Quote.self, from: data)
                    completetion(decodedQuote)
                } catch let error {
                    print("Error in getting Quote from API. \(error.localizedDescription)")
                    completetion (nil)
                }
            }
        }
        dataTask.resume()
    }
}
