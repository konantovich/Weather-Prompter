//
//  WeatherMain.swift
//  Weather prompter
//
//  Created by Antbook on 30.08.2021.
//

import Foundation



struct WeatherMain {
    
    var name: String = ""
    var count: Int = 0
    var temp: Double = 0.0
    var lat: Double = 0.0
    var conditionCodeIcon: String = ""
    var weatherDescription: String = ""
    var main: String = ""
    var presureMm: Double = 0.0
    var humidity: Double = 0.0
    var windSpeed: Double = 0
    var tempMin: Double = 0.0
    var tempMax: Double = 0.0
    var feelsLike: Double = 0.0
    
    //переводим таким образом
    var conditionString: String {
        switch main {
        case "Clear" : return "Ясно"
        case "Clouds" : return "Облачно"
        case "Rain" : return "Дождь"
        default:
            return self.main
        }

    }
    
    
    init?(weatherData: Welcome) {
        count = weatherData.count
        temp = weatherData.list[0].main.temp
        lat = weatherData.list[0].coord.lat
        conditionCodeIcon = weatherData.list[0].weather[0].icon
        weatherDescription = weatherData.list[0].weather[0].description
        main = weatherData.list[0].weather[0].main
        presureMm = weatherData.list[0].main.pressure
        humidity = weatherData.list[0].main.humidity
        windSpeed = weatherData.list[0].wind.speed
        tempMin = weatherData.list[0].main.temp_min
        tempMax = weatherData.list[0].main.temp_max
        feelsLike = weatherData.list[0].main.feels_like
    }
    
    init() {
        
    }
}
