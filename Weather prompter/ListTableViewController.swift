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
    var filterCityArray = [WeatherModel]()
    var newCity: String = ""
    
    
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
        
        setupNotifications()
        
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
        
        configureData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(senderWeather), name: NSNotification.Name.CityWasFetched, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(senderErrorWeather), name: NSNotification.Name.ErrorAddCity, object: nil)
    }
    
    @objc func senderErrorWeather () {
      
        CitiesWeatherManager.shared.allCitiesArray.removeLast()

 
            let alertController = UIAlertController(title: "Такого города не существует, попробуйте ввести еще раз", message: nil, preferredStyle: .alert)
            let alertInstall = UIAlertAction(title: "Ок", style: .default) { (action) in
               // self.addNewCityButton(UIBarButtonItem.init())
              //  self.configureData()
            }
            alertController.addAction(alertInstall)
          
            
            present(alertController, animated: true, completion: nil)
    
        
       
    
        
    }
    
    private func configureData() {
        
        self.citiesArray = CitiesWeatherManager.shared.allCitiesWeather.sorted { $0.name < $1.name }
        tableView.reloadData()
    }
    
    @objc func senderWeather () {
        configureData()
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
    //    }
    
    
    //MARK: - Table view data source
    //количество ячеек
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filterCityArray.count
        }
        //        CitiesWeatherManager.shared.allCitiesArray.count
        return citiesArray.count
    }
    
    //настройка ячеек
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ListCell
        
        
        if isFiltering {
            cell.configure(weather: filterCityArray[indexPath.row])
        } else {
            cell.configure(weather: citiesArray[indexPath.row])
        }
        
        return cell
    }
    
    //по нажатию на ячейку
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFiltering {
            CitiesWeatherManager.shared.selectedCity = filterCityArray[indexPath.row].name
            dismiss(animated: true, completion: nil)
        } else {
            CitiesWeatherManager.shared.selectedCity = citiesArray[indexPath.row].name
            
           
            
        }
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //добавляем новый город (алертом)
    @IBAction func addNewCityButton(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Введите название города", message: nil, preferredStyle: .alert)
        let alertInstall = UIAlertAction(title: "Ок", style: .default) { (action) in
            
            let textField = alertController.textFields?.first
            guard let text = textField?.text else { return }
            
            
            
            //            self.citiesManager.citiesArray.append(text)
            //            self.citiesManager.citiesWeather.append(self.emptyCity)
            
            
            print("CitiesWeatherManager.shared.allCitiesArray", CitiesWeatherManager.shared.allCitiesArray)
            
            
            if let city = CitiesWeatherManager.shared.allCitiesArray.firstIndex(of: "\(text)") {
               // CitiesWeatherManager.shared.allCitiesArray.remove(at: city)
                
                let alertControllerDublicat = UIAlertController(title:"Город уже добавлен", message: nil, preferredStyle: .alert)
                let alertDublicatCity = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
                alertControllerDublicat.addAction(alertDublicatCity)
                self.present(alertControllerDublicat, animated: true, completion: nil)
                
            } else {
                CitiesWeatherManager.shared.allCitiesArray.append(text)
                
                
                print(" CitiesWeatherManager.shared.allCitiesArray after add : ", CitiesWeatherManager.shared.allCitiesArray)
                
                self.tableView.reloadData()
            }
            
            
           
          
           
        }
        alertController.addTextField { (textField) in
            textField.placeholder = ""
        }
        
        let alertCancel = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        
        alertController.addAction(alertInstall)
        alertController.addAction(alertCancel)
        
        present(alertController, animated: true, completion: nil)
        
       
        
        
    }
    
    ///удаляем свайпом из тейбл вью
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [self] (_, _, complitionHandler) in
            
     
            let edditingRow = isFiltering ? filterCityArray[indexPath.row] : citiesArray[indexPath.row]
            
           // CitiesWeatherManager.shared.allCitiesArray.removeAll { $0 == edditingRow.name }
            if CitiesWeatherManager.shared.allCitiesArray != [] {
                CitiesWeatherManager.shared.allCitiesArray.removeAll { $0 == edditingRow.name }
               
            }
         
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
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


