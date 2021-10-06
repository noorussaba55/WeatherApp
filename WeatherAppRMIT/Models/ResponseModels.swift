//
//  ResponseModels.swift
//  WeatherAppRMIT
//
//  Created by Noor-us-saba Karim on 27/9/21.
//

/*
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation

struct CityWeather: Codable, Equatable {
    let lat: Float?
    let lon: Float?
    let timezone : String?
    let timezone_offset: Int?
    let current: Current?
    let hourly: [Hourly]?
    let daily: [Daily]?
    
    enum CodingKeys: String, CodingKey {

        case lat = "lat"
        case lon = "lon"
        case timezone = "timezone"
        case timezone_offset = "timezone_offset"
        case current = "current"
        case hourly = "hourly"
        case daily = "daily"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decodeIfPresent(Float.self, forKey: .lat)
        lon = try values.decodeIfPresent(Float.self, forKey: .lon)
        timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
        timezone_offset = try values.decodeIfPresent(Int.self, forKey: .timezone_offset)
        current = try values.decodeIfPresent(Current.self, forKey: .current)
        hourly = try values.decodeIfPresent([Hourly].self, forKey: .hourly)
        daily = try values.decodeIfPresent([Daily].self, forKey: .daily)
    }
}

struct Current: Codable, Equatable {
    var dt : Double?
    let temp: Double?
    let weather : [Weather]?
    let feels_like : Double?
    let pressure : Int?
    let humidity : Int?
    let dew_point : Double?
    let uvi : Double?
    let clouds : Int?
    let visibility : Int?
    let wind_speed : Double?
    let wind_deg : Int?
    let wind_gust : Double?
    
    enum CodingKeys: String, CodingKey {

        case dt = "dt"
        case temp = "temp"
        case feels_like = "feels_like"
        case pressure = "pressure"
        case humidity = "humidity"
        case dew_point = "dew_point"
        case uvi = "uvi"
        case clouds = "clouds"
        case visibility = "visibility"
        case wind_speed = "wind_speed"
        case wind_deg = "wind_deg"
        case wind_gust = "wind_gust"
        case weather = "weather"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dt = try values.decodeIfPresent(Double.self, forKey: .dt)
        temp = try values.decodeIfPresent(Double.self, forKey: .temp)
        feels_like = try values.decodeIfPresent(Double.self, forKey: .feels_like)
        pressure = try values.decodeIfPresent(Int.self, forKey: .pressure)
        humidity = try values.decodeIfPresent(Int.self, forKey: .humidity)
        dew_point = try values.decodeIfPresent(Double.self, forKey: .dew_point)
        uvi = try values.decodeIfPresent(Double.self, forKey: .uvi)
        clouds = try values.decodeIfPresent(Int.self, forKey: .clouds)
        visibility = try values.decodeIfPresent(Int.self, forKey: .visibility)
        wind_speed = try values.decodeIfPresent(Double.self, forKey: .wind_speed)
        wind_deg = try values.decodeIfPresent(Int.self, forKey: .wind_deg)
        wind_gust = try values.decodeIfPresent(Double.self, forKey: .wind_gust)
        weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
    }

}

struct Hourly:  Codable, Equatable  {
    let temp: Double?
    var dt : Double?
    let weather : [Weather]?
    
    enum CodingKeys: String, CodingKey {

        case dt = "dt"
        case temp = "temp"
        case weather = "weather"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dt = try values.decodeIfPresent(Double.self, forKey: .dt)
        temp = try values.decodeIfPresent(Double.self, forKey: .temp)
        weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
       
    }
    
}

struct Daily:  Codable, Equatable  {
    let temp: Temp?
    let dt : Double?
    let weather : [Weather]?
    
    enum CodingKeys: String, CodingKey {

        case dt = "dt"
        case temp = "temp"
        case weather = "weather"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dt = try values.decodeIfPresent(Double.self, forKey: .dt)
        temp = try values.decodeIfPresent(Temp.self, forKey: .temp)
        weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
       
    }
    
}

struct Temp: Codable, Equatable {
   
    let min : Double?
    let max : Double?
    
    enum CodingKeys: String, CodingKey {

        case min = "min"
        case max = "max"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        min = try values.decodeIfPresent(Double.self, forKey: .min)
        max = try values.decodeIfPresent(Double.self, forKey: .max)
    }
    
}

struct Weather:  Codable, Equatable {
    let id : Int?
    let main : String?
    let description : String?
    let icon : String?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case main = "main"
        case description = "description"
        case icon = "icon"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        main = try values.decodeIfPresent(String.self, forKey: .main)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
     }
    
}



