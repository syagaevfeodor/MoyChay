//
//  StringToHtmlExtension.swift
//  MoyChay
//
//  Created by Федор on 11.05.17.
//  Copyright © 2017 Федор. All rights reserved.
//

import Foundation

extension String {
    
    
    func getHTMLFromUrl() -> String{
        guard let myURL = URL(string: self) else {
            print("this URL is incorrect")
            return ""
        }
        do {
            return try String(contentsOf: myURL, encoding: .utf8)
            
        } catch {
            print("error: \(error)")
        }
        
        return ""
    }
    
    func saveImage() -> UIImage?{
        let myURL = URL(string: self)
        do {
            let data = try Data(contentsOf: myURL!)
            let image = UIImage(data: data)
            return image
        } catch {
            print("problems loading image, we handled this error: \(error)")
            return nil
        }
    }
    
}
