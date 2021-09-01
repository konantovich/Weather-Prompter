//
//  TableViewCell.swift
//  Weather prompter
//
//  Created by Antbook on 30.08.2021.
//


import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var nameCityLabel: UILabel!
    @IBOutlet weak var statusCityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    func configure (weather: WeatherMain) {
       
        nameCityLabel.isHidden = false
        self.nameCityLabel.text = weather.name
        self.statusCityLabel.text = weather.conditionString
        self.tempLabel.text = String(Int(weather.temp)) + "°C"
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
