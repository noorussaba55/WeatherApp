//
//  MainViewController.swift
//  WeatherAppRMIT
//
//  Created by Noor-us-saba Karim on 23/9/21.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource {

//TableView outlets and default values
    @IBOutlet var forecastTableView: UITableView!
    var forecastType = ForecastType.dailyForecast
       
    //Outlets for current weather description
    @IBOutlet var currentWeatherView: CurrentWeatherView!
    
//TabBar Items
    @IBOutlet var forecastTabBar: UITabBar!
    @IBOutlet var hourlyTabBarItem: UITabBarItem!
    @IBOutlet var dailyTabBarItem: UITabBarItem!
    
   
   //Weather data variables
    var weatherMAnager = WeatherApiManager()

    var weatherData:CityWeather?
    var locationInUseForWeather: CLLocation?
    var locationNameString: String = ""
    var usingSavedLocation: Bool = false
    
    //Spinner view variable
    var spinner = UIActivityIndicatorView()
    var opaqueView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up the table view and tab bar delegates
         forecastTableView.delegate = self
         forecastTableView.dataSource = self
         
         forecastTabBar.delegate = self
         forecastTabBar.selectedItem = dailyTabBarItem
         
         self.currentWeatherView.saveAsFavoriteButton.isHidden = true
         self.currentWeatherView.updateWeatherButton.isHidden = true
        
        //Fetch saved weather and update views
        usingSavedLocation = reloadSavedWeather()
        
        //if there's no saved location: use default location/Sydney , call weather API and update views
        if !usingSavedLocation{
            self.locationInUseForWeather = ChangeLocationViewController.nearbyLocationNamesDictionary["Sydney, Australia"]
            getWeatherForLocation(location: self.locationInUseForWeather!)
        }
        
    }
 //MARK:- Weather loading methods
    func reloadSavedWeather()->Bool{
      
        //If a weather is already saved as favorite load that onto current screen
        if let savedWeather = WeatherStorage.readFavoriteWeatherFromDisk(){
            
            self.weatherData = savedWeather
            
            //Set current user location from the saved weather
            guard let latitude = savedWeather.lat, let longitude = savedWeather.lon else {return false}
            self.locationInUseForWeather = CLLocation(latitude: Double(latitude), longitude: Double(longitude))
            
            //Change buttons UPDATE-> not Hidden because old weather is displayed, SAVE-> hidden bcz weather is already saved
            self.currentWeatherView.updateWeatherButton.isHidden = false
            self.currentWeatherView.saveAsFavoriteButton.isHidden = true
            
            //Update forecast table and current weather view
            self.updateCurrentWeatherView()
            self.forecastTableView.reloadData()
            
            return true
        }
          
        return false
    }
    
    func getWeatherForLocation(location: CLLocation){
        
        //start animation while data is fetching
            showOpaqueView()
            showSpinner()
        
        weatherMAnager.getWeatherForCity(city: location, completion_Handler: {weatherData in
            DispatchQueue.main.async {
                
                //UI updates to be done on main thread after api call
                
                //Map weather object on controller's data sources for table view
                self.weatherData = weatherData
                
                //Change buttons UPDATE-> Hidden because the weather is recent, SAVE->not hidden bcz new weather is fetched which is not on disk
                self.currentWeatherView.saveAsFavoriteButton.isHidden = false
                self.currentWeatherView.updateWeatherButton.isHidden = true
                
                
                //Update forecast table and current weather views
                self.updateCurrentWeatherView()
                self.forecastTableView.reloadData()
                
                //hide animation
                self.hideSpinnerAndOpacity()
            }
        })
    }
  //MARK:- UI update methods
    func updateCurrentWeatherView(){
        
        //Unwrapping api response optionals
        guard let weather = self.weatherData,
              let currentWeatherdata = weather.current,
              let date = currentWeatherdata.dt,
              let wind_deg = currentWeatherdata.wind_deg,
              let wind_speed = currentWeatherdata.wind_speed,
              let humidity = currentWeatherdata.humidity,
              let uvi = currentWeatherdata.uvi,
              let temp = currentWeatherdata.temp,
              let feels_like = currentWeatherdata.feels_like,
              let weatherArray = currentWeatherdata.weather,
              let weather = weatherArray.first,
              let icon = weather.icon,
              let description = weather.description  else{return}
        
        
        //fetching image from api
        weatherMAnager.fetchImage(icon: icon, completionHandler: {image in
            self.currentWeatherView.currentWeatherIconImageView.image = image
        })
        
        locationNameString = ChangeLocationViewController.currentLocationName(location: self.locationInUseForWeather)
        
        //Update all the ui labels with data
        self.currentWeatherView.currentWeatherLocationLabel.text = locationNameString
        self.currentWeatherView.currentWeatherDescriptionLabel.text = description
        self.currentWeatherView.currentWeatherTemperatureLabel.text = "Temp: \(temp)°"
        self.currentWeatherView.currentWeatherFeelsLikeTempratureLabel.text = "Feels Like: \(feels_like)°"
        self.currentWeatherView.currentWeatherUVIndexLabel.text = "UV Index: \(uvi)"
        self.currentWeatherView.currentWeatherHumidityLabel.text = "Humidity: \(humidity)"
        self.currentWeatherView.currentWeatherWindSpeedLabel.text = "Wind Speed: \(wind_speed)"
        self.currentWeatherView.currentWeatherWindDirectionLabel.text = "Wind Direction: \(wind_deg)"
        self.currentWeatherView.currentWeatherDateLabel.text = convertTimestampToString(epoch: date, requestFrom: "view")
    }
    
    
    //MARK:-NAVIGATION
    
    
    @IBAction func backToWeatherScreen(_ unwindSegue: UIStoryboardSegue) {
   
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "chooseLocationSegue"{
            let destinationVC = segue.destination as! ChangeLocationViewController
            destinationVC.senderVC = self
        }
        
    }
    
//MARK:- TABLEVIEW DATA SOURCE METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch forecastType {
        //For daily forecast return 7 cells for 7 days forecast
        case .dailyForecast:
            return 7
        //For hourly forecast return 24 cells for 24 hour forecast
        case .hourlyForecast:
            return 24
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell", for: indexPath) as! ForecastTableViewCell
        
        //Unwrap optionals from response
        guard let weather = weatherData, let daily = weather.daily, let hourly = weather.hourly else {
            return cell
        }
        
        switch forecastType {
        case .dailyForecast:
            do{
                //fetch daily Forecast data and set cell ui elements with it
                let dailyData = daily[indexPath.row+1]
               
                //Unwrapping values
                guard let timeStamp = dailyData.dt,
                      let weatherArray = dailyData.weather,
                      let weather = weatherArray.first,
                      let description = weather.description,
                      let icon = weather.icon,
                      let temp = dailyData.temp,
                      let maxTemp = temp.max,
                      let minTemp = temp.min
                else{return cell}
                   
                   // let timeStamp = dailyData.dt
                    cell.timeOrDayLabel.text = convertTimestampToString(epoch: timeStamp, requestFrom: "cell")
                    cell.weatherDescriptionLabel.text = description
                    cell.tempLabel.text = "\(Int(maxTemp))° - \(Int(minTemp))°"
                   weatherMAnager.fetchImage(icon: icon, completionHandler: {image in
                        cell.weatherIconImageView.image = image
                    })
            }
        case .hourlyForecast:
            
            do{
                //Fetch hourly forecast data and set ui elements of cell with it
                //fetch daily Forecast data and set cell ui elements with it
                let hourlyData = hourly[indexPath.row+1]
               
                //Unwrapping values
                guard let timeStamp = hourlyData.dt,
                      let weatherArray = hourlyData.weather,
                      let weather = weatherArray.first,
                      let description = weather.description,
                      let icon = weather.icon,
                      let temp = hourlyData.temp
                else{return cell}
                
                cell.timeOrDayLabel.text = convertTimestampToString(epoch: timeStamp, requestFrom: "cell")
                cell.weatherDescriptionLabel.text = description
                cell.tempLabel.text = "\(Int(temp))°"
                weatherMAnager.fetchImage(icon: icon, completionHandler: {image in
                        cell.weatherIconImageView.image = image
                
                })
            }
        }
        return cell
    }
    
//MARK:- TABLE VIEW DELEGATE METHODS

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//MARK:- TAB BAR DELEGATE METHOD
    
func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    //Switch the forecast table's data based on selection
    switch item.tag {
    case 0:
        forecastType = .dailyForecast
    case 1:
        forecastType = .hourlyForecast
    default:
        print("Error")
    }
    
    //Reload and scroll up with updated data
    forecastTableView.reloadData()
    forecastTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)

}

//MARK:- TimeStamp conversion method

    //Change epoch timestamp to appropriate strings
    func convertTimestampToString(epoch: Double, requestFrom: String)->String{
       
        let date = Date(timeIntervalSince1970: TimeInterval(epoch))
        let dateFormatter = DateFormatter()
    
        //to decide on what date format to convert using string Ids
        if requestFrom == "cell"{
            switch forecastType {
            case .dailyForecast:
                //In case of daily forecast, display name of the day
                //dateFormatter.dateFormat = "EEEE dd MMM, yyyy" //Day+date
                dateFormatter.dateFormat = "EEE" //Short name of the day
                let dayInWeek = dateFormatter.string(from: date)
                return dayInWeek
            case .hourlyForecast:
                //In case of hourly forecast, displpay time
                dateFormatter.dateFormat = "hh:mm aa" //AM/PM format
                //dateFormatter.dateFormat = "HH:mm" //24HR format
                let timeOfDay = dateFormatter.string(from: date)
                return timeOfDay
            }
        }
        else if requestFrom == "view"{
            //Convert date
            dateFormatter.dateFormat = "dd MMM, yyyy"
            let currentDate = dateFormatter.string(from: date)
            return currentDate
        }
        else{
            return "nil"
        }
    }
    
//MARK:- Button Actions
 
    @IBAction func saveWeatherAsFavoriteButtonTapped(_ sender: Any) {
       
     //Save current weather data to file
       showOpaqueView()
       showSpinner()
        
        //check if there is data to be saved
        if weatherData != nil{
             WeatherStorage.saveWeatherOnDisk(weatherData!)

        }
        
        //Show animation for 1 second while file is being saved, then change buttons
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.currentWeatherView.saveAsFavoriteButton.isHidden = true
            self.currentWeatherView.updateWeatherButton.isHidden = false
            self.hideSpinnerAndOpacity()
        }
        
        
    }
    
    @IBAction func updateWeather(_ sender: Any) {
        
        //Update the displayed weather for the location saved as part of favorite weather
        /*
        //Get location from displayed weather
        guard let latitude = weatherData?.lat, let longitude = weatherData?.lon else {
            return
        }
         */
        guard let city = self.locationInUseForWeather else {return}
        
        //Call weatherapi for saved location
        getWeatherForLocation(location: city)
        
    }
       
//MARK:- Animation methods
    
    func showOpaqueView(){
        //Opaque view to hide screen
       // let opaqueView = UIView()
        opaqueView.frame = self.view.frame
        opaqueView.backgroundColor = .white
        opaqueView.alpha = 0.8
        self.view.addSubview(opaqueView)
    }
    
    func showSpinner(){
        // Spinner shown during weather api call
     //   let spinner = UIActivityIndicatorView()
        spinner.style = UIActivityIndicatorView.Style.medium
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.center = self.view.center
        spinner.startAnimating()
        self.view.addSubview(spinner)
    }
    
    func hideSpinnerAndOpacity(){
        //Stop spinner after data and ui updates
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        //Remove opacity from view
        opaqueView.removeFromSuperview()
    }
}
