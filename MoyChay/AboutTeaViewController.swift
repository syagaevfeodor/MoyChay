//
//  AboutTeaViewController.swift
//  MoyChay
//
//  Created by Федор on 11.05.17.
//  Copyright © 2017 Федор. All rights reserved.
//

import UIKit
import Kanna
import CoreData


class AboutTeaViewController: UIViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var descriptionOfProduct: UITextView!
    var textOfTitle = ""
    var URLOfTea = ""
    var productPhotos = [UIImage]()
    var managedObjectContext: NSManagedObjectContext!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = textOfTitle
        parsingImages()
        
//        mainScrollView.frame = view.frame
        
        for i in 0..<productPhotos.count{
            let imageView = UIImageView()
            imageView.image = productPhotos[i]
            imageView.contentMode = .scaleAspectFit
            let width = self.view.frame.width
            let xPosition = width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: mainScrollView.frame.width, height: mainScrollView.frame.height)
            
            mainScrollView.contentSize.width = mainScrollView.frame.width * CGFloat(i + 1)
            mainScrollView.addSubview(imageView)
        }
        
//        descriptionOfProduct.text = ""
    }
    
    func parsingTeaDescription(for html: String) -> String {
        if let doc = HTML(html: html, encoding: .utf8) {
            
            for link in doc.css("article") {
                if link["class"] == "item-description" {
                    
                    for link2 in link.css("div") {
                        if link2["class"] == "description" {
                            return link2.text!
                        }
                    }
                    
                }
            }
        }
        
        return ""
    }
    
    func parsingImages() {
        let html = URLOfTea.getHTMLFromUrl()
        
        if let doc = HTML(html: html, encoding: .utf8) {
            
            for link in doc.css("img") {
                if link["class"] == "product_image" {
                    let url = "https://moychay.ru" + link["src"]!
                    let image = url.saveImage()
                    productPhotos.append(image!)
                }
            }
        }
        
        descriptionOfProduct.text = parsingTeaDescription(for: html)
    }
    
    
    
    @IBAction func addTeaToLibrary(_ sender: Any) {
        let alert = UIAlertController(title: "Добавить в любимое?", message: "", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Да", style: UIAlertActionStyle.default, handler: nil)
        let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    
}
