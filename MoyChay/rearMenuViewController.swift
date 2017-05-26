//
//  rearViewController.swift
//  MoyChay
//
//  Created by Федор on 16.05.17.
//  Copyright © 2017 Федор. All rights reserved.
//

import UIKit
import CoreData

class rearMenuViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    let menu = ["Новости", "Ассортимент", "Любимый чай", "Скидочная карта", "Контакты"]

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "rangeSegue" {
            let SWController = self.parent as! SWRevealViewController
            managedObjectContext = SWController.MOC
            let controller = segue.destination as! UINavigationController
            let rangeViewController = controller.topViewController as! rangeViewController
            rangeViewController.managedObjectContext = managedObjectContext
            print(managedObjectContext)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell")
        cell?.textLabel?.text = menu[index]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let cellLabelText = (cell?.textLabel?.text)!
        
        switch cellLabelText {
        case "Новости":
            performSegue(withIdentifier: "newsSegue", sender: nil)
        case "Контакты":
            performSegue(withIdentifier: "contactsSegue", sender: nil)
        case "Ассортимент":
            performSegue(withIdentifier: "rangeSegue", sender: nil)
        case "Любимый чай":
            performSegue(withIdentifier: "newsSegue", sender: nil)
        case "Скидочная карта":
            performSegue(withIdentifier: "discountCardSegue", sender: nil)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
