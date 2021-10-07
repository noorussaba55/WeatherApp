//
//  ChangeLocationViewController.swift
//  WeatherAppRMIT
//
//  Created by Noor-us-saba Karim on 1/10/21.
//

import UIKit
import CoreLocation

class ChangeLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet var availableLocationsTableView: UITableView!
    @IBOutlet var currentLocationLabel: UILabel!
    
    var senderVC: MainViewController!
   
    static  var nearbyLocationNamesDictionary:[String:CLLocation] = [
        "Sydney, Australia": CLLocation(latitude: Double(-33.8679), longitude: Double(151.2073)),
        "Melbourne, Australia": CLLocation(latitude: Double(-37.840935), longitude: Double(144.946457)),
        "Brisbane, Australia": CLLocation(latitude: Double(-27.470125), longitude: Double(153.021072)),
        "Adelaide, Australia": CLLocation(latitude: Double(-34.921230), longitude: Double(138.599503)),
        "Dubbo, Australia": CLLocation(latitude: Double(-32.256943), longitude: Double(148.601105)),
        "Canberra, Australia": CLLocation(latitude: Double(-35.282001), longitude: Double(149.128998)),
        "Perth, Australia": CLLocation(latitude: Double(-31.953512), longitude: Double(115.857048)),
        "Darwin, Australia": CLLocation(latitude: Double(-12.462827), longitude: Double(130.841782)),
        "Hobart, Australia": CLLocation(latitude: Double(-42.880554), longitude: Double(147.324997)),
        "Cairns, Australia": CLLocation(latitude: Double(-16.925491), longitude: Double(145.754120)),
        "Geelong, Australia": CLLocation(latitude: Double(-38.150002), longitude: Double(144.350006)),
        "Toowoomba, Australia": CLLocation(latitude: Double( -27.566668), longitude: Double(151.949997)),
        "Townsville, Australia": CLLocation(latitude: Double(-19.258965), longitude: Double(146.816956)),
        "Rockhampton, Australia": CLLocation(latitude: Double(-23.375000), longitude: Double(150.511673)),
        "Newcastle, Australia": CLLocation(latitude: Double(-32.916668), longitude: Double(151.7500)),
        "Alice springs, Australia": CLLocation(latitude: Double(-23.700552), longitude: Double(133.882675)),
        "Ballarat, Australia": CLLocation(latitude: Double(-37.549999), longitude: Double(143.850006)),
        "Tamworth, Australia": CLLocation(latitude: Double(-31.083332), longitude: Double(150.916672)),
        "Orange, Australia": CLLocation(latitude: Double(-33.283577), longitude: Double(149.101273)),
        "Goldcoast, Australia": CLLocation(latitude: Double(-28.016666), longitude: Double(153.399994))
    ]
    
    //array of strings for tableView data display
    var locationNames:[String]=[]
  
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        
        self.availableLocationsTableView.delegate = self
        self.availableLocationsTableView.dataSource = self
        
        //Get all city names
        self.locationNames = Array(ChangeLocationViewController.nearbyLocationNamesDictionary.keys)
        
        self.currentLocationLabel.text = ChangeLocationViewController.getCurrentLocationNameString(location: self.senderVC.locationInUseForWeather)
       
    }
    
   static func getCurrentLocationNameString(location: CLLocation?)->String{
        
        var nameString:String = "no name"
        
    //unwrap location object
        if let location = location{
            
            //Finding same location in our dictionary
            for (_,loc) in ChangeLocationViewController.nearbyLocationNamesDictionary{
               
                //Comparing coordinates rounded
                if (loc.coordinate.latitude.rounded() == location.coordinate.latitude.rounded()) && (loc.coordinate.longitude.rounded() == location.coordinate.longitude.rounded())
                {
                    //If found location in dictionary, use it's key as name string
                    let keyString = (ChangeLocationViewController.nearbyLocationNamesDictionary as NSDictionary).allKeys(for: loc) as! [String]
                    
                    nameString = keyString.first ?? "N/A"
                }
                
            }
        }
        return nameString
    }

//MARK:- TABLE VIEW DATA SOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ChangeLocationViewController.nearbyLocationNamesDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "locationNameCell", for: indexPath) as! LocationTableViewCell
        //Set city names to table view cells
        let locationNameString = locationNames[indexPath.row]
        cell.nameLabel.text = locationNameString
        return cell
    }

    //MARK:- TABLE VIEW DELEGATE METHODS

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            //Find Location object using selected index from names array
            let keyString = locationNames[indexPath.row]
            guard let selectedLocation = ChangeLocationViewController.nearbyLocationNamesDictionary[keyString] else{return}
            //Update location in use and fetch new weather data
            senderVC.locationInUseForWeather = selectedLocation
            senderVC.getWeatherForLocation(location: senderVC.locationInUseForWeather!)
        }

}

