//
//  discountViewController.swift
//  MoyChay
//
//  Created by Федор on 09.05.17.
//  Copyright © 2017 Федор. All rights reserved.
//

import UIKit
import CoreLocation
import Kanna
import MapKit

class contactsViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let manager = CLLocationManager()
    var cityName = ""
    let geocoder = CLGeocoder()
    let urlForContacts = "https://moychay.ru/sections/contact"
    var contacts = [contactsDataFormat]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        print("We are HERE")
        gettingUsersCurrentLocation()
    }
    
    func gettingUsersCurrentLocation() {
        manager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
        print("We are HERE2")
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.startUpdatingLocation()
        print("We are HERE3")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell") as! contactsCell
        let contact = contacts[indexPath.row]
        var phoneNumber = ""
        
        if contact.telephone2 != "" {
            phoneNumber = contact.telephone + "\n" + contact.telephone2
        } else {
            phoneNumber = contact.telephone
        }
        
        cell.addressButton.setTitle(contact.address, for: .normal)
        cell.phoneButton.setTitle(phoneNumber, for: .normal)
        cell.openingHoursLabel.text = contact.openingHours
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last!

        geocoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarksArray,_) -> Void in
            let placemark = placemarksArray?.last
            if let city = placemark?.locality {
                let cityInRussian = self.translateCityName(city: city)
                self.parsingContacts(cityName: cityInRussian)
                self.tableView.reloadData()
            }
        })
        
        manager.stopUpdatingLocation()
    }
    
    func translateCityName(city: String) -> String {
        if city == "Moscow" || city == "Москва" {
            return "Москва"
        }
        return ""
    }
    
    
    @IBAction func locationButton(_ sender: Any) {
        let button = sender as! UIButton
        var address = (button.titleLabel?.text)!
        let addressWithoutBackSlash = address.replacingOccurrences(of: "\\", with: "/")// В AppleMaps слеш ставится в другую сторону, чем на сайте МойЧай
        let newAddress = addressWithoutBackSlash.replacingOccurrences(of: ", стр.", with: "c")
        
        if address == "ул. Мясницкая, д. 24\\7, стр.2" { // В AppleMaps слеш ставится в другую сторону, чем на сайте МойЧай
            address = "ул. Мясницкая, 24/7с2"
        }

        print(address)

        geocoder.geocodeAddressString(newAddress) { (placemarksOptional, error) -> Void in
            if let placemarks = placemarksOptional {
                if let location = placemarks.first?.location {
                    print(location)
                    let query = "?ll=\(location.coordinate.latitude),\(location.coordinate.longitude)"
                    let path = "http://maps.apple.com/" + query
                    if let url = URL(string: path) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        print("Problems with creating url")
                    }
                } else {
                    print("problems getting location coordinates")
                }
            } else {
                // Didn't get any placemarks. Handle error.
            }
        }
    
    }
    
    @IBAction func phoneNumberButton(_ sender: Any) {
        let button = sender as! UIButton
        let phoneNumber = (button.titleLabel?.text)!
        let number = URL(string: "telprompt://" + phoneNumber)!
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    func callThePhoneNumber(phoneNumber: String) {
        
    }
    
    
    
    func parsingContacts(cityName: String){
        let html = urlForContacts.getHTMLFromUrl()
        var contact = contactsDataFormat()
        
        if let doc = HTML(html: html, encoding: .utf8) {

            for link in doc.css("li"){
                
                for link2 in link.css("a") {
                    if link2["itemprop"] == "telephone" {
                        if contact.telephone == "" {
                            contact.telephone = link2["content"]!
                        } else {
                            contact.telephone2 = link2["content"]!
                        }
                    }
                }
                
                
                for link2 in link.css("span"){
                    if link2["itemprop"] == "addressLocality" {
                        contact.city = link2.text!
                    }
                
                    if link2["itemprop"] == "streetAddress" {
                        contact.address = link2.text!
                    }
                
                    if link2["itemprop"] == "openingHours" {
                        contact.openingHours = link2.text!
                        if contact.city == cityName {
                            contacts.append(contact)
                            contact = contactsDataFormat()
                        }
                    }
                }
            }
            
        }
    }
    
    
}
