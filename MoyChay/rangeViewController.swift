//
//  rangeViewController.swift
//  MoyChay
//
//  Created by Федор on 09.05.17.
//  Copyright © 2017 Федор. All rights reserved.
//

import UIKit
import Kanna
import CoreData

class rangeViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var range = [rangeDataFormat]()
    var mainPageURL = "https://moychay.ru/catalog/main"
    var managedObjectContext: NSManagedObjectContext!
    let queue = DispatchQueue.global(qos: .userInteractive)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        

        parsingCategories()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return range.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rangeCell") as! rangeCell
        
        cell.rangeLabel.text = range[indexPath.row].nameOfProduct
        cell.rangeImageView.image = range[indexPath.row].image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedCategory" {
            let controller = segue.destination as! CategoryFromRangeViewController
            let cell = sender as! rangeCell
            let index = tableView.indexPath(for: cell)?.row
            let product = range[index!]
            controller.textOfTitle = product.nameOfProduct
            controller.urlOfCategory = product.categoryURL + "/view-all"
            controller.managedObjectContext = managedObjectContext
        }
    }
    
    
    func parsingCategories() {
        let html = mainPageURL.getHTMLFromUrl()

        
        if let doc = HTML(html: html, encoding: .utf8) {
            
            var product = rangeDataFormat()
            for link in doc.css("a") {
                
                if link["class"] == "item1" {
                    
//                    parsing name of the category
                    for link2 in link.css("span") {
                        if link2["class"] == "h4" {
                            product.nameOfProduct = link2.text!
                            product.categoryURL = "https://moychay.ru" + link["href"]!

                        }
                        
//                        parsing image
                        if link2["class"] == "img" && !product.hasImage{
                            for link3 in link2.css("img") {
                                product.imageURL = "https://moychay.ru/" + link3["src"]!
                                product.image = product.imageURL.saveImage()
                                product.hasImage = true
                            }
                        } else {
                            product = rangeDataFormat()
                            continue
                        }
                        range.append(product)
                    }
                }
            }
        }
    }
}
