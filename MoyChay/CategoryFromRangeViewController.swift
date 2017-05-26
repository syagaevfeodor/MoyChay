//
//  CategoryFromRangeViewController.swift
//  MoyChay
//
//  Created by Федор on 11.05.17.
//  Copyright © 2017 Федор. All rights reserved.
//

import UIKit
import Kanna
import CoreData

class CategoryFromRangeViewController: UITableViewController {
    
    var textOfTitle: String!
    var urlOfCategory: String!
    var teas = [teaDataFormat]()
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = textOfTitle
        parsingCategoryData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teaCell") as! teaCell
        let index = indexPath.row
        
        cell.teaLabel.text = teas[index].nameOfTea
        cell.teaImageView.image = teas[index].imageOfTea
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AboutTeaSegue"{
            let controller = segue.destination as! AboutTeaViewController
            let cell = sender as! UITableViewCell
            let index = tableView.indexPath(for: cell)?.row
            let tea = teas[index!]
            controller.textOfTitle = tea.nameOfTea
            controller.URLOfTea = tea.teaURL
            controller.managedObjectContext = managedObjectContext
        }
    }
    
    
    func parsingCategoryData() {
        let html = urlOfCategory.getHTMLFromUrl()
        
        if let doc = HTML(html: html, encoding: .utf8) {
            //parsing data
            for link in doc.css("a") {
                let tea = teaDataFormat()
                for link2 in link.css("img"){
                    if link2["class"] == "o_p_img" {
                        let lastAddedTea = teas.last
                    
                        if link2["src"] == nil {
                            continue
                        }
                    
                        if lastAddedTea?.nameOfTea != link2["alt"]! {
                            tea.nameOfTea = link2["alt"]!
                            tea.imageURL = "https://moychay.ru" + link2["src"]!
                            tea.hasImage = true
                            tea.imageOfTea = tea.imageURL.saveImage()
                            tea.teaType = textOfTitle
                            teas.append(tea)
                        } else {
                            teas.last?.teaURL = "https://moychay.ru" + link["href"]!
                            break
                        }
                    }
                }
                
            }
        }
    }
    
    @IBAction func showComments(_ sender: Any) {
    }
    

    @IBAction func showPhotos(_ sender: Any) {
    }
    
    @IBAction func showInformation(_ sender: Any) {
    }
    
    
}
