//
//  Service.swift
//  Weather prompter
//
//  Created by Antbook on 01.09.2021.
//

import Foundation

class CitiesWeatherManager {
    
    static let shared = CitiesWeatherManager()
    
    // Public properties
    var allCitiesWeather: [WeatherModel] = []
    
    /// Выбранный город
    var selectedCity: String {
        
        get {//достаем значение
            let defaults = UserDefaults.standard
            return defaults.string(forKey: "selectedCity") ?? "Лондон"
        }
        set (newValue) { // установить значение
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "selectedCity")
            defaults.synchronize()
            NotificationCenter.default.post(Notification(name: .SelectedCityWasChanged))
        }
    }
    
    /// Список всех городов
    var allCitiesArray: [String] {
        
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
            getAllCitiesWeather()
        }
    }
    
    
    
    // MARK: - Init
    
    init() {
        
        getAllCitiesWeather()
    }
    
    // MARK: - Public methods
    
    /// Находим погоду для текущего выбраного города
    func getWeatherForSelectedCity() -> WeatherModel? {
        print("Selected city: ", selectedCity)
       
        return getWeatherForCityName(cityName: selectedCity)
    }
    

    // MARK: - Private methods
    
    /// Находим погоду по имени города
    private func getWeatherForCityName(cityName: String) -> WeatherModel? {
        
        for city in allCitiesWeather {
            if city.name == cityName {
                return city
            }
        }
        
        return nil
    }
    
    //// Находим погоду для всех городов
    private func getAllCitiesWeather() {
        
        allCitiesWeather = []
        
        for city in allCitiesArray {
            getWeatherForCity(cityName: city)
        }
    }
    
    ///берем данные по погоде в зависимости от названия города
    private func getWeatherForCity(cityName: String) {
        
        NetworkWeatherManager2.shared.getCityWeather(cityName: cityName) { result in
            
            switch result {
            
            case .success(let weather):
                var newWeather = weather
                newWeather.name = cityName
                self.allCitiesWeather.append(newWeather)
                NotificationCenter.default.post(name: NSNotification.Name.CityWasFetched, object: nil)
            case .failure(let error):
                print("error get weather for city: ", error)
                NotificationCenter.default.post(name: NSNotification.Name.ErrorAddCity, object: nil)
            }

        }
    }
}
