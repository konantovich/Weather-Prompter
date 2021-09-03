//
//  NetworkWeatherManager.swift
//  Weather prompter
//
//  Created by Antbook on 30.08.2021.
//

import Foundation
import CoreLocation
import UIKit

class NetworkWeatherManager2 {
    
    static let shared = NetworkWeatherManager2()
 
    
    // MARK: - Public methods
    
    //берем данные по погоде в зависимости от названия города
    func getCityWeather(cityName: String, completionHandler: @escaping (WeatherModel) -> Void) {
        getCoordinateFrom(city: cityName) { (coordinate, error) in//получаем координаты
            
            
//            
//            if let error = error {
//                print("error add city", error.localizedDescription)
//               
//                NotificationCenter.default.post(name: NSNotification.Name.ErrorAddCity, object: nil)
//           
//            }
//           
            
            guard let coordinate = coordinate, error == nil else {return}
            
            //подставляем координаты в fetchWeather
            self.fetchCurrentWeather(latitude: coordinate.latitude, longitude: coordinate.longitude) { (weather) in
                DispatchQueue.main.async {
                    completionHandler(weather)
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    //получаем ссылку API (открываем url сессию) и подставляем координаты долготы/широты и тутже вызываем парсинг(получаем данные города) в зависимости от долготы и широты города
    private func fetchCurrentWeather(latitude: Double, longitude: Double, completionHandler: @escaping (WeatherModel) -> Void) {
           let urlString = "https://api.openweathermap.org/data/2.5/find?lat=\(latitude)&lon=\(longitude)&cnt=10&units=metric&lang=ru&appid=50bb086d1ad4c62c3ce2a0a515596674"
           guard let url = URL(string: urlString) else { return }
           
           var request = URLRequest(url: url, timeoutInterval: Double.infinity) //Double.infinity - бесконечность
           request.addValue("50bb086d1ad4c62c3ce2a0a515596674", forHTTPHeaderField: "Stalonam")
           request.httpMethod = "GET"
           
           let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            
            
            guard let data = data else {   return }
            
            
                  // print(String(describing: error))
               //print(String(data: data, encoding: .utf8)!)
            if let weather = self.parseJSON(withData: data) {
               
                completionHandler(weather)
                //print(weather)
            }
           }
           task.resume()
       }
    
    //подключаем/парсим модель API (Welcome) к нашей моделе (WeatherMain)
    private func parseJSON (withData data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
      // print(String(decoding: data, as: UTF8.self))
        do {
            let weatherData = try decoder.decode(Welcome.self, from: data)
        
            guard let weather = WeatherModel(weatherData: weatherData) else { return nil}
            return weather
            
        } catch let error as NSError {
            print("parse JSONE error: ",error.localizedDescription)
        }
        return nil
    }
    
    //получаем координаты города по названию города
    private func getCoordinateFrom(city: String, completion: @escaping (_ coordinate: CLLocationCoordinate2D?, _ error: Error?)-> ()) {
        CLGeocoder().geocodeAddressString(city) { (placemark, error) in
            
            completion(placemark?.first?.location?.coordinate, error)
        }
    }
    
    
    

}

