//
//  InfoViewController.swift
//  Weather prompter
//
//  Created by Antbook on 30.08.2021.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var averageTemp: UILabel!
    
    @IBOutlet weak var testImage: UIImageView!
    var weatherModel: WeatherModel?
    var citiesManager = CitiesWeatherManager()
    
    let imageCell = ["1", "2", "3"]
    
    var nameCities = "Киев"
    var nameCitiesArray = ["Москва", "Киев", "Берлин", "Харьков", "Лондон"]
    
    var currentColor = 0
    var colors = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green]
    
    @IBOutlet weak var adviceLabel: UILabel!
    
    @IBOutlet weak var clotheCollectionView: UICollectionView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(senderWeather), name: NSNotification.Name.init(rawValue: "red"), object: nil)
        
        
//        getWeatherForCity(cityName: "Киев")
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        imageView.backgroundColor = .none
        clotheCollectionView.backgroundColor = .none
        
        self.clotheCollectionView.delegate = self
        self.clotheCollectionView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    
    @objc func senderWeather () {
        DispatchQueue.main.async { [self] in
            self.nameCitiesArray = citiesManager.citiesArray
            self.weatherModel = citiesManager.citiesWeather[0]
        print("adsasd", citiesManager.citiesWeather[0].feelsLike)
            refreshLabels()
        
        }
       
     //  print(citiesManager.getWeatherForCity(cityName: nameCities))
        
        
    }
    
    // MARK: - Configure View
    
    func refreshLabels() {
        
        nameLabel.text = weatherModel?.name
        descriptionLabel.text = weatherModel!.weatherDescription
        tempLabel.text = "\(Int((weatherModel?.temp)!))" + "°C" + "\n" + " ощущается как " + "\(Int((weatherModel?.feelsLike)!))" + "°C"
        windSpeedLabel.text = "\(Int(weatherModel!.windSpeed))"
        humidity.text = "\(Int(weatherModel!.humidity))"
        averageTemp.text = "\((Int(weatherModel!.tempMax) + Int(weatherModel!.tempMin)) / 2)"
        pressureLabel.text = "\(Int(weatherModel!.presureMm))"
        
        
        windSpeedLabel.backgroundColor = windIndicator(wind: Int(weatherModel?.windSpeed ?? 10))
        humidity.backgroundColor = weatherHumidity(weatherHumidity: weatherModel?.humidity ?? 100)
        
        
        // подключил картинку .png по API ссылке
        let url = URL(string: "https://openweathermap.org/img/wn/\((weatherModel!.conditionCodeIcon))@2x.png")
        //print("https://openweathermap.org/img/wn/\((weatherModel!.conditionCodeIcon))@2x.png")
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url!) else { return }//make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.testImage.image = UIImage(data: data)
            }
        }
    }
    
    
}


// MARK: - Networking

extension InfoViewController {
    
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

//Collection View для отображения одежды
extension InfoViewController : UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if weatherModel == nil {
            return 0
        } else {
            return imageCell.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.backgroundColor = .red
        
        // cell.clotheImage.image = #imageLiteral(resourceName: "1")
        cell.layer.cornerRadius = 40
        
        let imageCell = imageCell[indexPath.row]
        
        switch imageCell {
        case "1":
            cell.backgroundColor = .none
            cell.clotheImage.image = jacketClotheTemperature(temp: Double(weatherModel!.feelsLike))
        case "2":
            cell.backgroundColor = .none
            cell.clotheImage.image = pantsClotheTemperature(temp: Double(weatherModel!.feelsLike))
        case "3":
            cell.backgroundColor = .none
            cell.clotheImage.image = bootsClotheTemperature(temp: Double(weatherModel!.feelsLike))
        default:
            cell.backgroundColor = .green
        }
        
        
        return cell
    }
    
    
    
    func jacketClotheTemperature (temp: Double) -> UIImage {
        
        switch temp {
        case -20.0..<0:
            return #imageLiteral(resourceName: "coat")
            
        case 0..<23:
            return #imageLiteral(resourceName: "clothes")
        case 23..<40:
            return #imageLiteral(resourceName: "tshirt")
        default:
            break
        }
        
        return #imageLiteral(resourceName: "tshirt")
        
    }
    
    func pantsClotheTemperature (temp: Double) -> UIImage {
        switch temp {
        case -20.0..<0:
            return #imageLiteral(resourceName: "trousers")
            
        case 0..<23:
            return #imageLiteral(resourceName: "trousers2")
        case 23..<40:
            return #imageLiteral(resourceName: "shorts")
        default:
            break
        }
        
        return #imageLiteral(resourceName: "tshirt")
    }
    
    func bootsClotheTemperature (temp: Double) -> UIImage{
        switch temp {
        case -20.0..<0:
            return #imageLiteral(resourceName: "boot")
            
        case 0..<23:
            return #imageLiteral(resourceName: "sneakers")
        case 23..<40:
            return #imageLiteral(resourceName: "slippers")
        default:
            break
        }
        
        return #imageLiteral(resourceName: "tshirt")
    }
    
    
    func windIndicator (wind: Int) -> UIColor {
        
        switch wind {
        case 0...5 :
            
            return UIColor(ciColor: .green)
        case 6...14:
            return UIColor(ciColor: .yellow)
        case 15...33:
            return UIColor(ciColor: .red)
        case 33...100:
            return UIColor(ciColor: .black)
            
        default:
            return UIColor(ciColor: .red)
        }
        
    }
    
    
    
    func advice () {
        
        let weatherTemp = weatherModel?.feelsLike ?? 10
        let wearherWind = weatherModel?.windSpeed ?? 10
        
        print(wearherWind)
        
        if weatherTemp < 10 && wearherWind <= 5{
            adviceLabel.text = "Довольно прохладно, но не супер холодно, так как ветер слабый"
        }
        if weatherTemp >= 10 && wearherWind <= 5{
            adviceLabel.text = "Тепло"
        }
        if weatherTemp >= 19 && wearherWind <= 5 {
            adviceLabel.text = "Очень тепло"
        }
        if weatherTemp <= 0 && wearherWind <= 5 {
            adviceLabel.text = "Похладненько"
        }
        if weatherTemp < 10 && wearherWind > 5 {
            adviceLabel.text = "Довольно прохладно и холодно"
        }
        if weatherTemp <= 0 && wearherWind > 5 {
            adviceLabel.text = "Очень холодно"
        } else {
            return
        }
        
    }
    
    func weatherHumidity (weatherHumidity: Double) -> UIColor {
        if weatherHumidity <= 60 && weatherHumidity >= 40 {
            return .green
        }
        if weatherHumidity <= 20 {
            return .red
        }
        if weatherHumidity >= 80 {
            return .orange
        }
        if weatherHumidity < 40  && weatherHumidity > 20 {
            return .yellow
        }
        if weatherHumidity < 80 && weatherHumidity > 60 {
            return .yellow
        }
        
        return .white
    }
}





