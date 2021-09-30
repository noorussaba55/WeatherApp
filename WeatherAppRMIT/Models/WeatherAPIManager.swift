//
//  WeatherAPIManager.swift
//  WeatherAppRMIT
//
//  Created by Noor-us-saba Karim on 23/9/21.
//

import Foundation
import UIKit

struct WeatherApiManager {
    
   /*
     One-Call URL: https://api.openweathermap.org/data/2.5/onecall?lat={lat}&lon={lon}&exclude={part}&appid={API key}&units=metric
     
     sample: https://api.openweathermap.org/data/2.5/onecall?lat=-33.8679&lon=151.2073&exclude=minutely&appid=190808429e6e59d2a9311582cde0dddb&units=metric
    */
    
    
   private let base_url: String = "https://api.openweathermap.org/data/2.5/onecall?exclude=minutely&units=metric&appid=190808429e6e59d2a9311582cde0dddb"

    
    mutating func getWeatherForCity(city: Location, completion_Handler: @escaping(CityWeather)->Void){
        
        //Create string with city info attached to base url
        let urlString = base_url+"&lat=\(city.latitude)&lon=\(city.longitude)"
        
        //create url from string
        guard let url = URL(string: urlString) else { return }
        
        
        //Call weather api
        fetchWeatherData(for: url, completionHandler: completion_Handler)
        
    }
    
    private func fetchWeatherData(for url:URL, completionHandler: @escaping(CityWeather)->Void){
        
        
        let urlRequest = URLRequest(url: url)
        let urlSession = URLSession(configuration: .default)
        
        
        let task = urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            //Check if there's any error with api call
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            //Validate response
            guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                    return
            }
            
            //Decoding to our model from response data
            if let data = data{
    
                let decodedWeatherForCity = try? JSONDecoder().decode(CityWeather.self, from: data)
               print(decodedWeatherForCity!)
                
                guard let weatherData = decodedWeatherForCity else { return }
                completionHandler(weatherData)
                
            }
            
        })
        
        task.resume()
    
   }
    
    
    func fetchImage(icon: String, completionHandler: @escaping(UIImage)->Void){
      
        // Create URL
           let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")!

           // Create Data Task
           let dataTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
               if let data = data {
                   DispatchQueue.main.async {
                       // Create Image and Pass it to caller of this function
                       let iconImage = UIImage(data: data)
                    completionHandler(iconImage ?? UIImage())
                   }
               }
           }

           // Start Data Task
           dataTask.resume()
    }
    
    
    
    
}
