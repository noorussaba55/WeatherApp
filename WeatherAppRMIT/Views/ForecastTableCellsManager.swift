//
//  ForecastTableCellsManager.swift
//  WeatherAppRMIT
//
//  Created by Noor-us-saba Karim on 28/9/21.
//

import Foundation
import UIKit


enum ForecastType: String{
    
    case dailyForecast = "DailyForecastCell"
    case hourlyForecast = "HourlyForecastCell"
    
}

class ForecastTableViewCell: UITableViewCell {
    
    //Fprecast Data outlets
    @IBOutlet var weatherDescriptionLabel: UILabel!
    @IBOutlet var timeOrDayLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var weatherIconImageView: UIImageView!
    
}
