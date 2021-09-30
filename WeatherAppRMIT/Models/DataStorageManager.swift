//
//  DataStorageManager.swift
//  WeatherAppRMIT
//
//  Created by Noor-us-saba Karim on 30/9/21.
//

import Foundation

class WeatherStorage{
    
    
    //default directory
    static private let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
       in: .userDomainMask).first!
    
    //URL where user's chosen location will be saved and read from
    static private let weatherFileURL =  documentsDirectory.appendingPathComponent("preferred_weather").appendingPathExtension("plist")
   
    static func saveWeatherOnDisk(_ weatherToSave: CityWeather) {
     
        // create the encoder
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        // create File URL
        let fileURL = WeatherStorage.weatherFileURL

    
        //Encode and write to file
        do {
            let data = try encoder.encode(weatherToSave)
            try data.write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
  
    static func readFavoriteWeatherFromDisk() -> CityWeather?{
      
        //create a decoder
        let decoder = PropertyListDecoder()
        
        //Create file URL
        let fileURL = WeatherStorage.weatherFileURL
        
        //fetch the data from disk
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        
        //decode the city name from data if retrieved
        let savedWeather = try? decoder.decode(CityWeather.self, from: data)
        return savedWeather
    }

}
