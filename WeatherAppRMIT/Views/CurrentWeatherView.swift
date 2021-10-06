//
//  CurrentWeatherView.swift
//  WeatherAppRMIT
//
//  Created by Noor-us-saba Karim on 1/10/21.
//

import UIKit

class CurrentWeatherView: UIView {
    
    //current view data labels
    @IBOutlet var currentWeatherDateLabel: UILabel!
    @IBOutlet var currentWeatherLocationLabel: UILabel!
    @IBOutlet var currentWeatherDescriptionLabel: UILabel!
    @IBOutlet var currentWeatherIconImageView: UIImageView!
    @IBOutlet var currentWeatherTemperatureLabel: UILabel!
    @IBOutlet var currentWeatherFeelsLikeTempratureLabel: UILabel!
    @IBOutlet var currentWeatherUVIndexLabel: UILabel!
    @IBOutlet var currentWeatherHumidityLabel: UILabel!
    @IBOutlet var currentWeatherWindSpeedLabel: UILabel!
    @IBOutlet var currentWeatherWindDirectionLabel: UILabel!
    
    //Save/Update button outlets
    @IBOutlet var saveAsFavoriteButton: UIButton!
    @IBOutlet var updateWeatherButton: UIButton!
    @IBOutlet var currentWeatherLocationButton: UIButton!


}
