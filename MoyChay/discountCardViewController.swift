//
//  discountCardViewController.swift
//  MoyChay
//
//  Created by Федор on 09.05.17.
//  Copyright © 2017 Федор. All rights reserved.
//

import UIKit

class discountCardViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var imageOfDiscountCard: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        imageOfDiscountCard.image = UIImage(named:"discount-card")
    }
    
}
