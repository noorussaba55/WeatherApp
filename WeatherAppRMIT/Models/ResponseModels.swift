//
//  ResponseModels.swift
//  WeatherAppRMIT
//
//  Created by Noor-us-saba Karim on 27/9/21.
//

import Foundation

struct CityWeather: Encodable, Decodable, Equatable {
    let lat: Float
    let lon: Float
    let timezone : String
    let timezone_offset: Int
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}

struct Current: Encodable, Decodable, Equatable {
    var dt : Double
    let temp: Double
    let weather : [Weather]
    let feels_like : Double
    let pressure : Int
    let humidity : Int
    let dew_point : Double
    let uvi : Double
    let clouds : Int
    let visibility : Int
    let wind_speed : Double
    let wind_deg : Int
    let wind_gust : Double
}

struct Hourly:  Encodable, Decodable, Equatable  {
    let temp: Double
    var dt : Double
    let weather : [Weather]
    
    
}

struct Daily:  Encodable, Decodable, Equatable  {
    let temp: Temp
    let dt : Double 
    let weather : [Weather]
}

struct Temp: Encodable, Decodable, Equatable {
   
    let min : Double
    let max : Double
}

struct Weather:  Encodable, Decodable , Equatable {
    let id : Int
    let main : String
    let description : String
    let icon : String
}
