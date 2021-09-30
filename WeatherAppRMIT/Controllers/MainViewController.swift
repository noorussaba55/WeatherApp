//
//  MainViewController.swift
//  WeatherAppRMIT
//
//  Created by Noor-us-saba Karim on 23/9/21.
//

import UIKit

class MainViewController: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource {

//TableView outlets and default values
    @IBOutlet var forecastTableView: UITableView!
    var forecastType = ForecastType.dailyForecast
       
    //Outlets for current weather description
    @IBOutlet var currentWeatherView: UIView!
    @IBOutlet var currentWeatherDateLabel: UILabel!
    @IBOutlet var currentWeatherLocationButton: UIButton!
    @IBOutlet var currentWeatherLocationLabel: UILabel!
    @IBOutlet var currentWeatherDescriptionLabel: UILabel!
    @IBOutlet var currentWeatherIconImageView: UIImageView!
    @IBOutlet var currentWeatherTemperatureLabel: UILabel!
    @IBOutlet var currentWeatherFeelsLikeTempratureLabel: UILabel!
    @IBOutlet var currentWeatherUVIndexLabel: UILabel!
    @IBOutlet var currentWeatherHumidityLabel: UILabel!
    @IBOutlet var currentWeatherWindSpeedLabel: UILabel!
    @IBOutlet var currentWeatherWindDirectionLabel: UILabel!
    
//TabBar Items
    @IBOutlet var forecastTabBar: UITabBar!
    @IBOutlet var hourlyTabBarItem: UITabBarItem!
    @IBOutlet var dailyTabBarItem: UITabBarItem!
    
   
   //Weather data variables
    var weatherMAnager = WeatherApiManager()

    var weatherData:CityWeather?
    
    
    //Save/Update button outlets
    @IBOutlet var saveAsFavoriteButton: UIButton!
    @IBOutlet var updateWeatherButton: UIButton!
    
    
    //Spinner view variable
    var spinner = UIActivityIndicatorView()
    var opaqueView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Setting up the table view and tab bar delegates
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        
        forecastTabBar.delegate = self
        forecastTabBar.selectedItem = dailyTabBarItem
        
        saveAsFavoriteButton.isHidden = true
        updateWeatherButton.isHidden = true
        
        //Fetch weather and update UI
        startLoadingWeather()

    }

    
    func startLoadingWeather(){
      
        
        //If a weather is already saved as favorite load that onto current screen, else call the api
        if let savedWeather = WeatherStorage.readFavoriteWeatherFromDisk(){
            
            self.weatherData = savedWeather
            self.updateCurrentWeatherView(weather: savedWeather)
            updateWeatherButton.isHidden = false
            saveAsFavoriteButton.isHidden = true
            //Update forecast table
            self.forecastTableView.reloadData()
            
            
        } else {
            //default/temporary location for the weather api
            let cityLocation = Location(latitude: -33.8679, longitude: 151.2073)
            getWeatherForLocation(location: cityLocation)
        }
        
    }
    
    func getWeatherForLocation(location: Location){
        
        //start animation while data is fetching
            showOpaqueView()
            showSpinner()
       
        weatherMAnager.getWeatherForCity(city: location, completion_Handler: {weatherData in
            DispatchQueue.main.async {
                
                //UI updates to be done on main thread after api call
                
                //Map weather object on controller's data sources for table view
                self.weatherData = weatherData
                self.saveAsFavoriteButton.isHidden = false
                self.updateWeatherButton.isHidden = true
                
                self.updateCurrentWeatherView(weather: weatherData)
                
                //Update forecast table
                self.forecastTableView.reloadData()
                
                //hide animation
                self.hideSpinnerAndOpacity()
                
                
            }
        })
    }
    
    func updateCurrentWeatherView(weather :CityWeather){
        
        
         let currentWeatherdata = weather.current
        
        weatherMAnager.fetchImage(icon: currentWeatherdata.weather.first!.icon, completionHandler: {image in
            self.currentWeatherIconImageView.image = image
            //Stretched backgroundImage
           // self.currentWeatherView.layer.contents = image.cgImage
        })
        //Update all the labels with data
        self.currentWeatherLocationLabel.text = weather.timezone
        self.currentWeatherDescriptionLabel.text = currentWeatherdata.weather.first!.description
        self.currentWeatherTemperatureLabel.text = "Temp: " + String( currentWeatherdata.temp) + "°"
        self.currentWeatherFeelsLikeTempratureLabel.text = "Feels Like: " + String(currentWeatherdata.feels_like) + "°"
        self.currentWeatherUVIndexLabel.text = "UV Index: " + String(currentWeatherdata.uvi)
        self.currentWeatherHumidityLabel.text = "Humidity: " + String(currentWeatherdata.humidity)
        self.currentWeatherWindSpeedLabel.text = "Wind Speed:: " + String(currentWeatherdata.wind_speed)
        self.currentWeatherWindDirectionLabel.text = "Wind Direction: " + String(currentWeatherdata.wind_deg)
        
        let date = Date(timeIntervalSince1970: TimeInterval(currentWeatherdata.dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let currentDate = dateFormatter.string(from: date)
        self.currentWeatherDateLabel.text = currentDate
    }
    
//MARK:- TABLEVIEW DATA SOURCE METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch forecastType {
        case .dailyForecast:
            return 7
        case .hourlyForecast:
            return 24
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell", for: indexPath) as! ForecastTableViewCell
        
        switch forecastType {
        case .dailyForecast:
            do{
                //fetch daily Forecast data and set cell ui elements with it
                if let dailyData = weatherData?.daily[indexPath.row+1] {
                   
                    let timeStamp = dailyData.dt
                    cell.timeOrDayLabel.text = convertTimestampToString(epoch: timeStamp)
                    cell.weatherDescriptionLabel.text = dailyData.weather.first?.description
                    cell.tempLabel.text = "\(Int(dailyData.temp.max))° - \(Int(dailyData.temp.min))°"
                   weatherMAnager.fetchImage(icon: dailyData.weather.first!.icon, completionHandler: {image in
                        cell.weatherIconImageView.image = image
                    })
                }
                
            }
        case .hourlyForecast:
            
            do{
                //Fetch hourly forecast data and set ui elements of cell with it
                if let hourData = weatherData?.hourly[indexPath.row+1]{
                    let timeStamp = hourData.dt
                    cell.timeOrDayLabel.text = convertTimestampToString(epoch: timeStamp)
                    cell.weatherDescriptionLabel.text = hourData.weather.first?.description
                    
                    cell.tempLabel.text = "\(Int(hourData.temp))°"
                    weatherMAnager.fetchImage(icon: hourData.weather.first!.icon, completionHandler: {image in
                        cell.weatherIconImageView.image = image
                    })
                    
                }
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
    
    //Reload and scroll up with changed data
    forecastTableView.reloadData()
    forecastTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)

}

//MARK:- Custom methods

    //Change epoch timestamp to appropriate strings
    func convertTimestampToString(epoch: Double)->String{
       
        let date = Date(timeIntervalSince1970: TimeInterval(epoch))
        let dateFormatter = DateFormatter()
    
        switch forecastType {
        case .dailyForecast:
          //  dateFormatter.dateFormat = "EEEE dd MMM, yyyy"
            dateFormatter.dateFormat = "EEE"
            let dayInWeek = dateFormatter.string(from: date)
            return dayInWeek
        case .hourlyForecast:
            dateFormatter.dateFormat = "hh:mm aa" //AM/PM format
            //dateFormatter.dateFormat = "HH:mm" //24HR format
            let timeOfDay = dateFormatter.string(from: date)
            return timeOfDay
        }
    }
    

    @IBAction func changeLocationButtonTapped(_ sender: Any) {
        
        print("Change location segue")
    }
    
    @IBAction func saveWeatherAsFavoriteButtonTapped(_ sender: Any) {
       
     //Save current weather data to file
       showOpaqueView()
       showSpinner()
        
        if weatherData != nil{
             WeatherStorage.saveWeatherOnDisk(weatherData!)

        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.saveAsFavoriteButton.isHidden = true
            self.updateWeatherButton.isHidden = false
            self.hideSpinnerAndOpacity()
        }
        
        
    }
    
    @IBAction func updateWeather(_ sender: Any) {
        
        print("Update weather for saved location")
        
        //Get location from saved weather
        guard let latitude = weatherData?.lat, let longitude = weatherData?.lon else {
            return
        }
        
        let city = Location(latitude: latitude, longitude: longitude)
        
        //Call weatherapi for saved location
        getWeatherForLocation(location: city)
        
    }
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
