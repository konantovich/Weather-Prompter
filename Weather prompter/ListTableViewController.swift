//
//  ListTableViewController.swift
//  Weather prompter
//
//  Created by Antbook on 30.08.2021.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    
    var emptyCity = WeatherModel()
    
    var citiesArray = [WeatherModel]()
    var nameCitiesArray = ["Москва", "Киев", "Берлин", "Харьков", "Лондон"]
    var newCity: String = ""
    
    var citiesManager = CitiesWeatherManager()
    
    var weatherModel: WeatherModel?
    
    
    var filterCityArray = [WeatherModel]()
    let searchController = UISearchController(searchResultsController: nil) //отображение строки поиска в этом же VC
    
    //когда обращаемся к searchBar, если текст уже введен то переменная будет меняется, если нет то просто выходим и false
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    //когда произошла фильтрация по имени или же нет
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(senderWeather), name: NSNotification.Name.init(rawValue: "red"), object: nil)
        
   
        //когда призапуске первый раз наш массив пустой, добавляем в него наш массив
        if citiesArray.isEmpty {
            citiesArray = Array(repeating: emptyCity, count: nameCitiesArray.count)
           
            
        }
       
        //addCities()
       
        
        
        //   networkWeatherManager.fetchWeather { (weatherMain) in print(weatherMain)}
        print("api.openweathermap.org/data/2.5/weather?q=London&appid=50bb086d1ad4c62c3ce2a0a515596674")
        //api.openweathermap.org/data/2.5/find?lat=55.5&lon=37.5&cnt=10&appid=50bb086d1ad4c62c3ce2a0a515596674
        
        //настройки поиска
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
       
    }
    
    @objc func senderWeather () {
        DispatchQueue.main.async { [self] in
            self.nameCitiesArray = citiesManager.citiesArray
            self.citiesArray = citiesManager.citiesWeather
        print("List", citiesManager.citiesWeather[0].feelsLike)
            tableView.reloadData()
          
        
        }
       

//    //получили координаты и еще раз привязали правильное имя города
//    func addCities () {
//        getCityWeather(citiesArray: self.nameCitiesArray) { (index, weatherMain) in
//
//
//
//
//            DispatchQueue.main.async { //так как таблица у нас прогружается раньше чем мы получаем данные, добавили обновление таблицы в основной поток
//                print(self.nameCitiesArray)
//
//
//
//                self.citiesArray[index] = weatherMain
//                self.citiesArray[index].name = self.nameCitiesArray[index]
//                self.tableView.reloadData()
//            }
//
//        }
    }
    
    
    //MARK: - Table view data source
    //количество ячеек
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filterCityArray.count
        }
        return citiesArray.count
    }
    
    //настройка ячеек
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ListCell
        
       
        
        
        
        if isFiltering {
            weatherModel = filterCityArray[indexPath.row]
            
        } else {
            weatherModel = citiesArray[indexPath.row]
        }
        
        
        cell.configure(weather: weatherModel!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        //weatherModel = citiesArray[indexPath.row]
       let index = citiesArray[indexPath.row]
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    //добавляем новый город (алертом)
    @IBAction func addNewCityButton(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Введите название города", message: nil, preferredStyle: .alert)
        let alertInstall = UIAlertAction(title: "Ок", style: .default) { (action) in
            
            let textField = alertController.textFields?.first
            guard let text = textField?.text else { return }
            //  self.newCity = text
            
            self.citiesManager.citiesArray.append(text)
        

            self.citiesManager.citiesWeather.append(self.emptyCity)
            self.tableView.reloadData()
            
            //print(self.nameCitiesArray)
         //   self.addCities()
            print("Добавили новый город:" + self.newCity)
            
            
          
            
            
        }
        alertController.addTextField { (textField) in
            textField.placeholder = self.newCity
        }
        
        let alertCancel = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        
        alertController.addAction(alertInstall)
        alertController.addAction(alertCancel)
        
        present(alertController, animated: true, completion: nil)
        self.tableView.reloadData()
        
    }
    
    //удаляем свайпом из тейбл вью
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [self] (_, _, complitionHandler) in
            
            let edditingRow = citiesManager.citiesArray[indexPath.row]
            
            if let index = citiesManager.citiesArray.firstIndex(of: edditingRow) {
                if self.isFiltering {
                    self.filterCityArray.remove(at: index)
                } else {
                    self.citiesArray.remove(at: index)
                    citiesManager.citiesArray.remove(at: index)
                    
                    let defaults = UserDefaults.standard
                    defaults.set(citiesManager.citiesArray, forKey: "SavedStringArray")
                    defaults.synchronize()
                    
                    
                }
                
            }

            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let webVC = segue.destination as! InfoViewController
        self.weatherModel = webVC.weatherModel
        
        webVC.refreshLabels()
        print("succes prepare")
//        if segue.identifier == "showDetail"{
//            guard let indexPath = tableView.indexPathForSelectedRow else { return }
//
//            if isFiltering {
//                let filter = filterCityArray[indexPath.row]
//                let infoVC = segue.destination as! InfoViewController
//                infoVC.weatherModel = filter
//            } else {
//                let cityWeather = citiesArray[indexPath.row]
//                let infoVC = segue.destination as! InfoViewController
//                infoVC.weatherModel = cityWeather
//                // print(cityWeather)
//            }
//
//        }
    }
    
}


//поисковик
extension ListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    //весь текст который будем вводить в текст филд, будем его брать и по нему искать
    private func filterContentForSearchText (_ searchText: String){
        filterCityArray = citiesArray.filter{
            $0.name.contains(searchText)
        }
        
        tableView.reloadData()
    }
    
}


