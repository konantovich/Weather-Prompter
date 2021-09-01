//
//  File.swift
//  Weather prompter
//
//  Created by Antbook on 30.08.2021.
//

import Foundation

//API структура

struct Welcome: Decodable {
    let count: Int
    let list: [List]

}


struct List: Decodable {
 //   let name: String
 //   let id: Int
    let main: WeatherMainValues//MainClass
    let id: Int
    let name: String
    let coord: Coord
    let weather: [Weather]
    let sys: Sys
    let wind: Wind
 
 //   let weather: Weather
}

struct Coord: Decodable {
    let lat: Double
    let lon: Double
}

struct WeatherMainValues: Decodable {
    
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Double
}

struct Weather: Decodable {
    
    let main: String
    let description: String  //Parts
    let icon: String
}

struct Sys: Decodable  {
    let country: String
}
//struct MainClass: Decodable {
//    let temp: Double
//  //  let tempMin, tempMax: Double
////    let pressure: Int
//
////    enum CodingKeys: String, CodingKey {
////        case temp
////        case tempMin = "temp_min"
////        case tempMax = "temp_max"
////        case pressure
////    }
//}
//
//

//
//    enum MainEnum: String, Codable {
//        case clear = "Clear"
//        case clouds = "Clouds"
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case main
//        case weatherDescription = "description"
//        case icon
//    }
//}
//
struct Wind: Decodable {
    let speed: Double
    let deg: Int
}


