//
//  newsViewController.swift
//  MoyChay
//
//  Created by Федор on 09.05.17.
//  Copyright © 2017 Федор. All rights reserved.
//

import UIKit
import Kanna

class newsViewController: UITableViewController{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var newsCells = [newsData]()
    let newsURL = "https://moychay.ru/media/news"
    var myHtmlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        newsParser()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsCells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! newsCell
        let index = indexPath.row
        
        
        cell.newsLabel.text = newsCells[index].descriptionOfNews
        cell.imageOfNews.image = newsCells[index].imageOfNews
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    func newsParser(){
        myHtmlString = newsURL.getHTMLFromUrl()
        
        if let doc = HTML(html: myHtmlString, encoding: .utf8) {
            
            for link in doc.css("a") {
                if link["tooltip"] == "news"{
                    let news = newsData()
                    var photoAdded = false
                    
                    
                    // parsing images link
                    for link2 in link.css("img") {
                        news.imageURL = "https://moychay.ru" + link2["src"]!
                        news.imageOfNews = news.imageURL.saveImage()
                        news.newsID = link["news_id"]!
                        photoAdded = true
                        
                    }
                    
                    if photoAdded {
                        newsCells.append(news)
                        continue
                    }
                    
                    //parsing news text
                    for new in newsCells {
                        if new.newsID == link["news_id"] {
                            new.descriptionOfNews = link.text!
                        }
                    }
                }
            }
        }
    }
}
