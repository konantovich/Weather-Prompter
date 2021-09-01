//
//  NetworkWeatherManager.swift
//  Weather prompter
//
//  Created by Antbook on 30.08.2021.
//

import Foundation
import CoreLocation


struct NetworkWeatherManager {
    
    //получаем ссылку API (открываем url сессию) и подставляем координаты долготы/широты
    func fetchCurrentWeather(latitude: Double, longitude: Double, completionHandler: @escaping (WeatherMain) -> Void) {
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
    func parseJSON (withData data: Data) -> WeatherMain? {
        let decoder = JSONDecoder()
      // print(String(decoding: data, as: UTF8.self))
        do {
            let weatherData = try decoder.decode(Welcome.self, from: data)
        
            guard let weather = WeatherMain(weatherData: weatherData) else { return nil}
            return weather
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
}




let networkWeatherManager = NetworkWeatherManager()

 //перебираем массив городов и в комплишин передаем индекс и его погоду
func getCityWeather (citiesArray: [String], completionHandler: @escaping (Int, WeatherMain) -> Void) {
    for (index, item) in citiesArray.enumerated() { //index это индекс в массиве, item значение (пример: 0:Москва)
        getCoordinateFrom(city: item) { (coordinate, error) in//получаем координаты
            guard let coordinate = coordinate, error == nil else {return}
            
            //подставляем координаты в fetchWeather
            networkWeatherManager.fetchCurrentWeather(latitude: coordinate.latitude, longitude: coordinate.longitude) { (weather) in
                completionHandler(index, weather)
            }
            
        }
        
    }
}

//получаем координаты города
func getCoordinateFrom(city: String, completion: @escaping (_ coordinate: CLLocationCoordinate2D?, _ error: Error?)-> ()) {
    CLGeocoder().geocodeAddressString(city) { (placemark, error) in
        completion(placemark?.first?.location?.coordinate, error)
    }
}
