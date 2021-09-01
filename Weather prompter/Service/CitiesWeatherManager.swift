//
//  Service.swift
//  Weather prompter
//
//  Created by Antbook on 01.09.2021.
//

import Foundation


class CitiesWeatherManager {
    
    var citiesWeather: [WeatherModel] = []
    
   public var dispatchGroup = DispatchGroup()
    
    init() {
        
        getAllCitiesWeather()
    }
    
    var citiesArray: [String] {
        
        get {//достаем значение
            let defaults = UserDefaults.standard
            if let citiesArray = defaults.array(forKey: "citiesArray") as? [String] {
                return citiesArray
            } else {
                return ["Москва", "Киев", "Берлин", "Харьков", "Лондон"]
            }
        }
        set (newValue) { // установить значение
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "citiesArray")
            defaults.synchronize()
        }
    }
    
    //берем данные по погоде в зависимости от названия города
    func getWeatherForCity(cityName: String) {
        
        NetworkWeatherManager2.shared.getCityWeather(cityName: cityName) { weather in
            
            DispatchQueue.global().async(group: self.dispatchGroup) {
                var newWeather = weather
                newWeather.name = cityName
                self.citiesWeather.append(newWeather)
                
                
                NotificationCenter.default.post(name: NSNotification.Name.init("red"), object: self)
            }
                
               
           
            
        }
    }
    
    func getAllCitiesWeather() {
        
        citiesWeather = []
        
        for city in citiesArray {
            getWeatherForCity(cityName: city)
            
        }
    }
    
    
    
}
